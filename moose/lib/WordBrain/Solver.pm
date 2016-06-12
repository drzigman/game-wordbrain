package WordBrain::Solver;

use strict;
use warnings;

use MooseX::Params::Validate;
use Storable qw( dclone );
use Data::Util qw( is_hash_ref );

use WordBrain::Types qw( ArrayRef Game Letter Letters NaturalInt Str Word );

use WordBrain::Game;
use WordBrain::Letter;
use WordBrain::Word;

use Text::Aspell;
use Readonly;
Readonly my $SPELLER => Text::Aspell->new;
$SPELLER->set_option( 'lang', 'en_US' );
$SPELLER->set_option( 'sug-mode', 'fast' );

use Exporter qw( import );
our @EXPORT_OK = qw( find_near_letters find_near_words spellcheck_word );

# No MooseX::Params::Valdiate for Performance Reasons
sub find_near_letters {
    my %args = @_ == 1 && is_hash_ref( $_[0] ) ? %{ $_[0] } : @_;

    my @near_letters;
    for my $row_offset ( -1, 0, 1 ) {
        for my $col_offset ( -1, 0, 1 ) {
            if( $row_offset == 0 && $col_offset == 0 ) {
                ### Skipping Center Letter
                next;
            }

            my $near_row_number = $args{row_number} + $row_offset;
            my $near_col_number = $args{col_number} + $col_offset;

            my $letter = $args{game}->get_letter_at_position(
                row => $near_row_number,
                col => $near_col_number,
            );

            if( !$letter ) {
                next;
            }

            if( grep { $_ == $letter } @{ $args{used} } ) {
                ### Skipping Already Used Letter
                next;
            }

            push @near_letters, $letter;
        }
    }

    return \@near_letters;
}

# No MooseX::Params::Valdiate for Performance Reasons
sub find_near_words {
    my %args = @_ == 1 && is_hash_ref( $_[0] ) ? %{ $_[0] } : @_;

    $args{used} //= [ ];
    $args{max_word_length} //= scalar @{ $args{game}->letters };

    return _find_near_words(
        word_root => WordBrain::Word->new( letters => [ $args{letter} ] ),
        letter    => $args{letter},
        game      => $args{game},
        used      => $args{used},
        max_word_length => $args{max_word_length},
    );
}

# No MooseX::Params::Valdiate for Performance Reasons
sub _find_near_words {
    my %args = @_ == 1 && is_hash_ref( $_[0] ) ? %{ $_[0] } : @_;

    push @{ $args{used} }, $args{letter};

    if( scalar @{ $args{word_root}->letters } >= $args{max_word_length} ) {
        return [ ];
    }

    my @words;
    my $near_letters = find_near_letters(
        used       => $args{used},
        game       => $args{game},
        row_number => $args{letter}->row,
        col_number => $args{letter}->col,
    );

    for my $near_letter (@{ $near_letters }) {
        my $new_word_root = WordBrain::Word->new(
            letters => [ @{ $args{word_root}->letters }, $near_letter ]
        );

        push @words, $new_word_root;

        my $near_letter_used = dclone $args{used};

        push @words, @{
            _find_near_words(
                word_root => $new_word_root,
                letter    => $near_letter,
                game      => $args{game},
                used      => $near_letter_used,
                max_word_length => $args{max_word_length},
            );
        };
    }

    return \@words;
}

sub spellcheck_word {
    my ( $word ) = pos_validated_list( \@_, { isa => Word } );

    return $SPELLER->check( $word->word );
}

1;
