package WordBrain::Solver;

use strict;
use warnings;

use MooseX::Params::Validate;

use WordBrain::Types qw( ArrayRef Game NaturalInt );

use Exporter qw( import );
our @EXPORT_OK = qw( find_near_letters );

sub find_near_letters {
    my ( %args ) = validated_hash(
        \@_,
        used       => { isa => ArrayRef },
        game       => { isa => Game },
        row_number => { isa => NaturalInt },
        col_number => { isa => NaturalInt },
    );

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

            if( $args{used}->[ $near_row_number ][ $near_col_number ] > 0 ) {
                ### Skipping Already Used Letter
                next;
            }

            push @near_letters, $letter;
        }
    }

    return \@near_letters;
}

1;
