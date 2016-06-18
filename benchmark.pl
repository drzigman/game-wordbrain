#!/usr/bin/env perl

use strict;
no warnings;

use Time::HiRes qw( gettimeofday tv_interval );

use WordBrain::WordToFind;
use WordBrain::Letter;
use WordBrain::Game;

use Getopt::Long;

my $playfield;
my @length_of_words_to_find;

my $got_valid_options = GetOptions(
    'playfield=s'    => \$playfield,
    'word-to-find=i' => \@length_of_words_to_find,
);

my $game = build_game( $playfield, \@length_of_words_to_find );
run_game( $game );

sub build_game {
    my ( $playfield, $length_of_words_to_find ) = @_;

    my @words_to_find;
    for my $length ( @{ $length_of_words_to_find } ) {
        push @words_to_find, WordBrain::WordToFind->new({ num_letters => $length });
    }

    my @raw_letters = split( '', $playfield );

    my ( $rows, $cols );
    $rows = $cols = sqrt( scalar @raw_letters );

    my @letters;
    for( my $row = 0; $row < $rows; $row++ ) {
        for( my $col = 0; $col < $cols; $col++ ) {
            push @letters, WordBrain::Letter->new({
                letter => shift @raw_letters,
                row    => $row,
                col    => $col,
            });
        }
    }

    return WordBrain::Game->new({
        letters       => \@letters,
        words_to_find => \@words_to_find,
    });
}

sub run_game {
    my $game = shift;

    my $start_time = [ gettimeofday ];

    $game->solve();

    my $run_time = tv_interval( $start_time );

    print "$run_time";
}
