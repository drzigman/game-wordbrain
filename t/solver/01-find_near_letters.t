#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

use WordBrain::Solver qw( find_near_letters );

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
    ]
);

Readonly my $NONE_USED => [
    [qw( 0 0 0 )],
    [qw( 0 0 0 )],
    [qw( 0 0 0 )],
];


subtest 'Middle - Nothing Used' => sub {
    my $near_letters;
    lives_ok {
        $near_letters = find_near_letters({
            used       => $NONE_USED,
            game       => $GAME,
            row_number => 1,
            col_number => 1,
        });
    } 'Lives through finding near letters';

    cmp_ok( scalar @{ $near_letters }, '==', 8, 'Correct number of near letters' );

    for my $expected_letter (qw( a b c d f g h i )) {
        ok( ( grep { $_->letter eq $expected_letter } @{ $near_letters } ), "Correctly found $expected_letter" );
    }
};

subtest 'Middle - Some Used' => sub {
    my $used = [
        [qw( 1 1 0 )],
        [qw( 0 0 1 )],
        [qw( 0 1 0 )],
    ];

    my $near_letters;
    lives_ok {
        $near_letters = find_near_letters({
            used       => $used,
            game       => $GAME,
            row_number => 1,
            col_number => 1,
        });
    } 'Lives through finding near letters';

    cmp_ok( scalar @{ $near_letters }, '==', 4, 'Correct number of near letters' );

    for my $expected_letter (qw( c d g i )) {
        ok( ( grep { $_->letter eq $expected_letter } @{ $near_letters } ), "Correctly found $expected_letter" );
    }
};

subtest 'Middle - All Used' => sub {
    my $used = [
        [qw( 1 1 1 )],
        [qw( 1 0 1 )],
        [qw( 1 1 1 )],
    ];

    my $near_letters;
    lives_ok {
        $near_letters = find_near_letters({
            used       => $used,
            game       => $GAME,
            row_number => 1,
            col_number => 1,
        });
    } 'Lives through finding near letters';

    cmp_ok( scalar @{ $near_letters }, '==', 0, 'Correct number of near letters' );
};

subtest 'Top Left' => sub {
    my $near_letters;
    lives_ok {
        $near_letters = find_near_letters({
            used       => $NONE_USED,
            game       => $GAME,
            row_number => 0,
            col_number => 0,
        });
    } 'Lives through finding near letters';

    cmp_ok( scalar @{ $near_letters }, '==', 3, 'Correct number of near letters' );

    for my $expected_letter (qw( b d e )) {
        ok( ( grep { $_->letter eq $expected_letter } @{ $near_letters } ), "Correctly found $expected_letter" );
    }
};

subtest 'Top Right' => sub {
    my $near_letters;
    lives_ok {
        $near_letters = find_near_letters({
            used       => $NONE_USED,
            game       => $GAME,
            row_number => 0,
            col_number => 2,
        });
    } 'Lives through finding near letters';

    cmp_ok( scalar @{ $near_letters }, '==', 3, 'Correct number of near letters' );

    for my $expected_letter (qw( b e f )) {
        ok( ( grep { $_->letter eq $expected_letter } @{ $near_letters } ), "Correctly found $expected_letter" );
    }
};

subtest 'Bottom Left' => sub {
    my $near_letters;
    lives_ok {
        $near_letters = find_near_letters({
            used       => $NONE_USED,
            game       => $GAME,
            row_number => 2,
            col_number => 0,
        });
    } 'Lives through finding near letters';

    cmp_ok( scalar @{ $near_letters }, '==', 3, 'Correct number of near letters' );

    for my $expected_letter (qw( d e h )) {
        ok( ( grep { $_->letter eq $expected_letter } @{ $near_letters } ), "Correctly found $expected_letter" );
    }
};

subtest 'Bottom Right' => sub {
    my $near_letters;
    lives_ok {
        $near_letters = find_near_letters({
            used       => $NONE_USED,
            game       => $GAME,
            row_number => 2,
            col_number => 2,
        });
    } 'Lives through finding near letters';

    cmp_ok( scalar @{ $near_letters }, '==', 3, 'Correct number of near letters' );

    for my $expected_letter (qw( e f h  )) {
        ok( ( grep { $_->letter eq $expected_letter } @{ $near_letters } ), "Correctly found $expected_letter" );
    }
};

done_testing;
