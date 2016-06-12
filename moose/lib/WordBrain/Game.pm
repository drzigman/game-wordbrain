package WordBrain::Game;

use strict;
use warnings;

use Moose;
use MooseX::Params::Validate;
use MooseX::StrictConstructor;
use Data::Util qw( is_hash_ref );
use namespace::autoclean;

use WordBrain::Types qw( Letters NaturalInt WordsToFind Word Solutions );

use WordBrain::Solution;
use WordBrain::Word;

use WordBrain::Solver qw( find_near_words spellcheck_word );

use Storable qw( dclone );
use List::Util qw( first );
use List::MoreUtils qw( first_index );

has letters => (
    is       => 'ro',
    isa      => Letters,
    required => 1,
    coerce   => 1,
);

has words_to_find => (
    is       => 'ro',
    isa      => WordsToFind,
    required => 1,
);

has solutions => (
    is       => 'ro',
    isa      => Solutions,
    required => 0,
    writer   => '_set_solutions',
);

sub solve {
    my $self = shift;

    my $max_word_length = 0;
    for my $word_to_find (@{ $self->words_to_find }) {
        if( $max_word_length < $word_to_find->num_letters ) {
            $max_word_length = $word_to_find->num_letters;
        }
    }

    my @solutions;
    for my $letter (@{ $self->letters }) {
        my $possible_words = find_near_words(
            letter => $letter,
            game   => $self,
            max_word_length => $max_word_length,
        );

        my @actual_words;
        for my $possible_word (@{ $possible_words }) {
            if( grep { $_->num_letters == length ( $possible_word->word ) } @{ $self->words_to_find } ) {
                if( spellcheck_word( $possible_word ) ) {
                    push @actual_words, $possible_word;
                }
            }
        }


        for my $word ( @actual_words ) {
            if( scalar @{ $self->words_to_find } > 1 ) {
                my $updated_game           = $self->construct_game_without_word( $word );
                my $updated_game_solutions = $updated_game->solve();

                for my $updated_game_solution (@{ $updated_game_solutions }) {
                    if( $word->word eq 'doll' && $updated_game_solution->words->[0]->word eq 'idols') {
                        use Data::Dumper;
                        print Dumper( $self );
                        print Dumper( $updated_game );
                    }

                    push @solutions, WordBrain::Solution->new(
                        words => [ $word, @{ $updated_game_solution->words } ],
                    );
                }
            }
            else {
                push @solutions, WordBrain::Solution->new(
                    words => [ $word ],
                );
            }
        }
    }

    $self->_set_solutions( \@solutions );
}

sub construct_game_without_word {
    my $self = shift;
    my ( $found_word ) = pos_validated_list( \@_, { isa => Word } );

    my $words_to_find = dclone $self->words_to_find;
    my $index_of_found_word = first_index {
        $_->num_letters == scalar @{ $found_word->letters }
    } @{ $self->words_to_find };

    splice @{ $words_to_find }, $index_of_found_word, 1;

    my @new_letters;
    for my $letter (@{ $self->letters }) {
        if( grep { $_ == $letter } @{ $found_word->letters } ) {
            next;
        }

        my $num_letters_used_below = grep {
               $_->col == $letter->col
            && $_->row >  $letter->row
        } @{ $found_word->letters };

        push @new_letters, WordBrain::Letter->new(
            letter => $letter->letter,
            row    => $letter->row + $num_letters_used_below,
            col    => $letter->col,
        );
    }

    return $self->new(
        letters       => \@new_letters,
        words_to_find => $words_to_find,
    );
}

# No MooseX::Params::Valdiate for Performance Reasons
sub get_letter_at_position {
    my $self = shift;
    my %args = @_ == 1 && is_hash_ref( $_[0] ) ? %{ $_[0] } : @_;

    return first {
           $_->row == $args{row}
        && $_->col == $args{col}
    } @{ $self->letters };
}

__PACKAGE__->meta->make_immutable;

1;
