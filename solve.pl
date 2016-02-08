#!/usr/bin/env perl

use strict;
use warnings;
use v5.14;

use Text::Aspell;

my $game = [
    [qw( h e o c )],
    [qw( s o n b )],
    [qw( u r m a )],
    [qw( b t r p )],
];

print_game();
my $used_positions;
my $possible_strings = process_game();
my $valid_words = filter_valid_words( $possible_strings );

for my $valid_word (@{ $valid_words }) {
    if( length ( $valid_word ) == 3 ) {
        print $valid_word . "\n";
    }
}

sub print_game {
    print "===== GAME =====\n";
    for my $row_number ( 0 .. 3 ) {
        for my $col_number ( 0 .. 3 ) {
            print $game->[$row_number][$col_number] . "\t";
        }
        print "\n";
    }
    print "================\n";
}

sub process_game {
    my @possible_strings;
    for my $row_number ( 0 .. 3 ) {
        for my $col_number ( 0 .. 3 ) {
            $used_positions = [
                [qw( 0 0 0 0 )],
                [qw( 0 0 0 0 )],
                [qw( 0 0 0 0 )],
                [qw( 0 0 0 0 )],
            ];

            $used_positions->[ $row_number ][ $col_number ]++;

            push @possible_strings, @{
                find_near_words( $game->[$row_number][$col_number], $row_number, $col_number )
            };
        }
    }

    return \@possible_strings;
}

sub filter_valid_words {
    my $possible_strings = shift;

    my $speller = Text::Aspell->new;
    $speller->set_option('lang','en_US');
    $speller->set_option('sug-mode','fast');

    my %valid_strings;
    for my $possible_string (@{ $possible_strings }) {
        if( $speller->check( $possible_string ) ) {
            $valid_strings{ $possible_string }++;
        }
    }

    return [ keys %valid_strings ];
}

sub find_near_words {
    my $base_string = shift;
    my $row_number  = shift;
    my $col_number  = shift;

    if( $row_number < 0 || $row_number > 3 ) {
        return [];
    }

    if( $col_number < 0 || $col_number > 3 ) {
        return [];
    }

    print "Base String: $base_string\n";
    print "Row Number : $row_number\n";
    print "Col Number : $col_number\n";


    if( length( $base_string ) > 3 ) {
        return [ ];
    }

    my @near_letters = find_near_letters( $row_number, $col_number );

    $used_positions->[ $row_number ][ $col_number ]++;

    my @possible_strings;
    for my $near_letter ( @near_letters ) {
        if( $near_letter ) {
            my $working_string = $base_string . $near_letter;
            push @possible_strings, $working_string;

            for my $next_row_number_offset ( -1, 0, 1 ) {
                for my $next_col_number_offset ( -1, 0, 1 ) {
                    if( $next_row_number_offset == 0 && $next_col_number_offset == 0 ) {
                        next;
                    }

                    my $next_row_number = $row_number + $next_row_number_offset;
                    my $next_col_number = $col_number + $next_col_number_offset;

                    if( $next_row_number < 0 || $next_row_number > 3 ) {
                        next;
                    }

                    if( $next_col_number < 0 || $next_col_number > 3 ) {
                        next;
                    }

                    if( $used_positions->[ $next_row_number ][ $next_col_number ] ) {
                        next;
                    }

                    print "Base String Offset: $base_string\n";
                    print "Next Row Offset: $next_row_number_offset\n";
                    print "Next Col Offset: $next_col_number_offset\n";
                    print "Next Row Number: $next_row_number\n";
                    print "Next Col Number: $next_col_number\n";

                    push @possible_strings, @{ find_near_words( $working_string, $next_row_number, $next_col_number ) };
                    $used_positions->[ $next_row_number ][ $next_col_number ]--;
                }
            }
        }
    }

    return \@possible_strings;
}


sub find_near_letters {
    my $row_number = shift;
    my $col_number = shift;

    if( $row_number < 0 || $row_number > 3 || $col_number < 0 || $col_number > 3 ) {
        return ( );
    }

    print "Location ( $row_number x $col_number )\n";
    print "Letter: " . $game->[$row_number][$col_number] . "\n";

    my ( $top, $top_right, $right, $bottom_right, $bottom, $bottom_left, $left, $top_left );

    ( $row_number - 1 >= 0 && $col_number - 0 >= 0 && !$used_positions->[ $row_number - 1 ][ $col_number - 0 ])
            and $top          = $game->[ $row_number - 1 ][ $col_number - 0 ];

    ( $row_number - 1 >= 0 && $col_number + 1 < 4  && !$used_positions->[ $row_number - 1 ][ $col_number + 1 ])
            and $top_right    = $game->[ $row_number - 1 ][ $col_number + 1 ];

    ( $row_number + 0 >= 0 && $col_number + 1 < 4  && !$used_positions->[ $row_number + 0 ][ $col_number + 1 ])
            and $right        = $game->[ $row_number + 0 ][ $col_number + 1 ];

    ( $row_number + 1 < 4  && $col_number + 1 < 4  && !$used_positions->[ $row_number + 1 ][ $col_number + 1 ])
            and $bottom_right = $game->[ $row_number + 1 ][ $col_number + 1 ];

    ( $row_number + 1 < 4  && $col_number - 0 >= 0 && !$used_positions->[ $row_number + 1 ][ $col_number - 0 ])
            and $bottom       = $game->[ $row_number + 1 ][ $col_number - 0 ];

    ( $row_number + 1 < 4  && $col_number - 1 >= 0 && !$used_positions->[ $row_number + 1 ][ $col_number - 1 ])
            and $bottom_left  = $game->[ $row_number + 1 ][ $col_number - 1 ];

    ( $row_number + 0 >= 0 && $col_number - 1 >= 0 && !$used_positions->[ $row_number + 0 ][ $col_number - 1 ])
            and $left         = $game->[ $row_number + 0 ][ $col_number - 1 ];

    ( $row_number - 1 >= 0 && $col_number - 1 >= 0 && !$used_positions->[ $row_number - 1 ][ $col_number - 1 ])
            and $top_left     = $game->[ $row_number - 1 ][ $col_number - 1 ];

=cut
    print "Top         : " . ( $top          // '' ) . "\n";
    print "Top Right   : " . ( $top_right    // '' ) . "\n";
    print "Right       : " . ( $right        // '' ) . "\n";
    print "Bottom Right: " . ( $bottom_right // '' ) . "\n";
    print "Bottom      : " . ( $bottom       // '' ) . "\n";
    print "Bottom Left : " . ( $bottom_left  // '' ) . "\n";
    print "Left        : " . ( $left         // '' ) . "\n";
    print "Top Left    : " . ( $top_left     // '' ) . "\n";
=cut

    return ( $top, $top_right, $right, $bottom_right, $bottom, $bottom_left, $left, $top_left );
}
