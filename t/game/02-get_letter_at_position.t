#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

use WordBrain::Game;
use WordBrain::Letter;

use Readonly;
Readonly my $GAME => WordBrain::Game->new(
    letters => [
        { letter => 'a', row => 0, col => 0 },
        { letter => 'b', row => 0, col => 1 },
        { letter => 'c', row => 0, col => 2 },
        { letter => 'd', row => 1, col => 0 },
        { letter => 'e', row => 1, col => 1 },
        { letter => 'f', row => 1, col => 2 },
        { letter => 'g', row => 2, col => 0 },
        { letter => 'h', row => 2, col => 1 },
        { letter => 'i', row => 2, col => 2 },
    ],
    words_to_find => [ ],
);

subtest 'Get Letter At Position That Has No Letter' => sub {
    my $letter;
    lives_ok {
        $letter = $GAME->get_letter_at_position(
            row => 99,
            col => 99,
        );
    } 'Lives through fetching letter';

    ok( !defined $letter, 'No letter at specified position' );
};

subtest 'Get Letter At Position That Has Letter' => sub {
    my $letter;
    lives_ok {
        $letter = $GAME->get_letter_at_position(
            row => 1,
            col => 2,
        );
    } 'Lives through fetching letter';

    isa_ok( $letter, 'WordBrain::Letter' );
    cmp_ok( $letter->letter, 'eq', 'f', 'Correct letter' );
    cmp_ok( $letter->row, '==', 1, 'Correct row' );
    cmp_ok( $letter->col, '==', 2, 'Correct col' );
};

done_testing;
