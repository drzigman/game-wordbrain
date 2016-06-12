#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

use WordBrain::Letter;
use WordBrain::WordToFind;
use WordBrain::Game;

subtest 'Coerce From ArrayRef[HashRef]' => sub {
    my $word_to_find = WordBrain::WordToFind->new( num_letters => 5 );

    my @letter_hashrefs;
    my @letter_chars = (qw( a b c d e f g h i ));

    for my $row_number ( 0 .. 2 ) {
        for my $col_number ( 0 .. 2 ) {
            push @letter_hashrefs, {
                letter => $letter_chars[ ( $row_number * 3 ) + $col_number ],
                row    => $row_number,
                col    => $col_number,
            };
        }
    }

    my $game;
    lives_ok {
        $game = WordBrain::Game->new(
            letters       => \@letter_hashrefs,
            words_to_find => [ $word_to_find ],
        );
    } 'Lives through creation of Game';

    isa_ok( $game, 'WordBrain::Game' );

    cmp_ok( scalar @{ $game->letters }, '==', scalar @letter_hashrefs, 'Correct Number of Letters' );

    for my $row_number ( 0 .. 2 ) {
        for my $col_number ( 0 .. 2 ) {
            subtest "Letter At $row_number x $col_number" => sub {
                my $letter = $game->letters->[ ( $row_number * 3 ) + $col_number ];

                isa_ok( $letter, 'WordBrain::Letter' );
                cmp_ok( $letter->letter, 'eq', $letter_chars[ ( $row_number * 3 ) + $col_number ], 'Correct letter' );
                cmp_ok( $letter->row, '==', $row_number, 'Correct row_number' );
                cmp_ok( $letter->col, '==', $col_number, 'Correct col_number' );
            };
        }
    }
};

done_testing;
