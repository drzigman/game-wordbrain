package WordBrain::Game;

use strict;
use warnings;

use WordBrain::Letter;
use WordBrain::Word;
use WordBrain::Solution;
use WordBrain::WordToFind;
use WordBrain::Prefix;

use Storable qw( dclone );
use List::Util qw( reduce first );
use List::MoreUtils qw( first_index );

use Text::Aspell;


=head2 new

    my $letters       = [ WordBrain::Letter->... ];
    my $words_to_find = [ WordBrain::WordToFind->... ];
    my $speller       = Text::Aspell->new;

    my $game = WordBrain::Game->new({
        letters       => $letters,
        words_to_find => $words_to_find,
        speller       => $speller,       # optional
        prefix        => $prefix,        # optional
    });

=cut

sub new {
    my $class = shift;
    my $args  = shift;

    if( !exists $args->{solutions} ) {
        $args->{solutions} = undef;
    }

    if( !exists $args->{speller} ) {
        $args->{speller} = Text::Aspell->new;
        $args->{speller}->set_option( 'lang', 'en_US' );
        $args->{speller}->set_option( 'sug-mode', 'fast' );
    }

    if( !exists $args->{prefix} ) {
        my $largest_word_to_find = reduce {
            $a->{num_letters} > $b->{num_letters} ? $a : $b
        } @{ $args->{words_to_find} };

        $args->{prefix} = WordBrain::Prefix->new({
            max_prefix_length => $largest_word_to_find->{num_letters}
        });
    }

    return bless $args, $class;
}

sub solve {
    my $self = shift;

    my $max_word_length = 0;
    for my $word_to_find (@{ $self->{words_to_find} }) {
        if( $max_word_length < $word_to_find->{num_letters} ) {
            $max_word_length = $word_to_find->{num_letters};
        }
    }

    my @solutions;
    for my $letter (@{ $self->{letters} }) {
        my $possible_words = $self->find_near_words({
            letter => $letter,
            max_word_length => $max_word_length,
        });

        my @actual_words;
        for my $possible_word (@{ $possible_words }) {
            if( grep { $_->{num_letters} == length ( $possible_word->word ) } @{ $self->{words_to_find} } ) {
                if( $self->spellcheck_word( $possible_word ) ) {
                    push @actual_words, $possible_word;
                }
            }
        }


        for my $word ( @actual_words ) {
            if( scalar @{ $self->{words_to_find} } > 1 ) {
                my $updated_game           = $self->construct_game_without_word( $word );
                my $updated_game_solutions = $updated_game->solve();

                for my $updated_game_solution (@{ $updated_game_solutions }) {
                    push @solutions, WordBrain::Solution->new({
                        words => [ $word, @{ $updated_game_solution->{words} } ],
                    });
                }
            }
            else {
                push @solutions, WordBrain::Solution->new({
                    words => [ $word ],
                });
            }
        }
    }

    $self->{solutions} = \@solutions;
}

=head2 construct_game_without_word

    my $word = WordBrain::Word->...;
    my $game = WordBrain::Game->...;

    my $sub_game = $game->construct_game_without_word( $word );

=cut

sub construct_game_without_word {
    my $self       = shift;
    my $found_word = shift;

    my $words_to_find = dclone $self->{words_to_find};
    my $index_of_found_word = first_index {
        $_->{num_letters} == scalar @{ $found_word->{letters} }
    } @{ $self->{words_to_find} };

    splice @{ $words_to_find }, $index_of_found_word, 1;

    my @new_letters;
    for my $letter (@{ $self->{letters} }) {
        if( grep { $_ == $letter } @{ $found_word->{letters} } ) {
            next;
        }

        my $num_letters_used_below = grep {
               $_->{col} == $letter->{col}
            && $_->{row} >  $letter->{row}
        } @{ $found_word->{letters} };

        push @new_letters, WordBrain::Letter->new({
            letter => $letter->{letter},
            row    => $letter->{row} + $num_letters_used_below,
            col    => $letter->{col},
        });
    }

    return WordBrain::Game->new({
        letters       => \@new_letters,
        words_to_find => $words_to_find,
        speller       => $self->{speller},
        prefix        => $self->{prefix},
    });
}

=head2 get_letter_at_position

    my $game = WordBrain::Game->...
    my $letter = $game->get_letter_at_position({
        row => 2,
        col => 3,
    });

=cut

sub get_letter_at_position {
    my $self = shift;
    my $args = shift;

    return first {
           $_->{row} == $args->{row}
        && $_->{col} == $args->{col}
    } @{ $self->{letters} };
}

=head2 find_near_letters

    my $game = WordBrain::Game->...
    my $near_letters = $game->find_near_letters({
        used       => [ ... ],
        row_number => 1,
        col_number => 1,
    });

=cut

sub find_near_letters {
    my $self = shift;
    my $args = shift;

    my @near_letters;
    for my $row_offset ( -1, 0, 1 ) {
        for my $col_offset ( -1, 0, 1 ) {
            if( $row_offset == 0 && $col_offset == 0 ) {
                ### Skipping Center Letter
                next;
            }

            my $near_row_number = $args->{row_number} + $row_offset;
            my $near_col_number = $args->{col_number} + $col_offset;

            my $letter = $self->get_letter_at_position({
                row => $near_row_number,
                col => $near_col_number,
            });

            if( !$letter ) {
                next;
            }

            if( grep { $_ == $letter } @{ $args->{used} } ) {
                ### Skipping Already Used Letter
                next;
            }

            push @near_letters, $letter;
        }
    }

    return \@near_letters;
}

=head2 find_near_words

    my $game = WordBrain::Game->...;
    my $near_words = $game->find_near_words({
        letter          => WordBrain::Letter->...,
        used            => [ ],   # Optional
        max_word_length => 5,     # Optional
    });

=cut

sub find_near_words {
    my $self = shift;
    my $args = shift;

    $args->{used} //= [ ];
    $args->{max_word_length} //= scalar @{ $self->{letters} };

    return $self->_find_near_words({
        word_root => WordBrain::Word->new({ letters => [ $args->{letter} ] }),
        letter    => $args->{letter},
        used      => $args->{used},
        max_word_length => $args->{max_word_length},
    });
}

sub _find_near_words {
    my $self = shift;
    my $args = shift;

    push @{ $args->{used} }, $args->{letter};

    if( scalar @{ $args->{word_root}->{letters} } >= $args->{max_word_length} ) {
        return [ ];
    }

    if( !$self->{prefix}->is_start_of_word( $args->{word_root} ) ) {
        return [ ];
    }

    my @words;
    my $near_letters = $self->find_near_letters({
        used       => $args->{used},
        game       => $args->{game},
        row_number => $args->{letter}{row},
        col_number => $args->{letter}{col},
    });

    for my $near_letter (@{ $near_letters }) {
        my $new_word_root = WordBrain::Word->new({
            letters => [ @{ $args->{word_root}{letters} }, $near_letter ]
        });

        push @words, $new_word_root;

        my $near_letter_used = dclone $args->{used};

        push @words, @{
            $self->_find_near_words({
                word_root => $new_word_root,
                letter    => $near_letter,
                used      => $near_letter_used,
                max_word_length => $args->{max_word_length},
            });
        };
    }

    return \@words;
}

sub spellcheck_word {
    my $self = shift;
    my $word = shift;

    return $self->{speller}->check( $word->word );
}

1;
