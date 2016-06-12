#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

use WordBrain::Letter;
use WordBrain::Word;
use WordBrain::WordToFind;
use WordBrain::Game;

subtest '3x3 - Remove 1 Word' => sub {
    my @letters;
    push @letters, WordBrain::Letter->new( letter => 'l', row => 0, col => 0 );
    push @letters, WordBrain::Letter->new( letter => 's', row => 0, col => 1 );
    push @letters, WordBrain::Letter->new( letter => 'e', row => 0, col => 2 );
    push @letters, WordBrain::Letter->new( letter => 'l', row => 1, col => 0 );
    push @letters, WordBrain::Letter->new( letter => 'i', row => 1, col => 1 );
    push @letters, WordBrain::Letter->new( letter => 'd', row => 1, col => 2 );
    push @letters, WordBrain::Letter->new( letter => 'l', row => 2, col => 0 );
    push @letters, WordBrain::Letter->new( letter => 'o', row => 2, col => 1 );
    push @letters, WordBrain::Letter->new( letter => 'd', row => 2, col => 2 );

    my @words_to_find;
    push @words_to_find, WordBrain::WordToFind->new( num_letters => 5 );
    push @words_to_find, WordBrain::WordToFind->new( num_letters => 4 );


    my @found_words;
    push @found_words, WordBrain::Word->new(
        letters => [
            WordBrain::Letter->new( letter => 'd', row => 2, col => 2 ),
            WordBrain::Letter->new( letter => 'o', row => 2, col => 1 ),
            WordBrain::Letter->new( letter => 'l', row => 2, col => 0 ),
            WordBrain::Letter->new( letter => 'l', row => 1, col => 0 ),
        ]
    );

    my $game;
    lives_ok {
        $game = WordBrain::Game->new(
            letters => \@letters,
            words_to_find => \@words_to_find,
        );
    } 'Lives through building game';

    my $updated_game;
    lives_ok {
        $updated_game = $game->construct_game_without_word( $found_words[0] );
    } 'Lives through constructing game without word';

    subtest 'Inspect Words To Find' => sub {
        cmp_ok( scalar @{ $updated_game->words_to_find }, '==', 1, 'Correct number of words to find' );
        cmp_ok( $updated_game->words_to_find->[0]->num_letters, '==', 5, 'Correct number of letters' );
    };

    subtest 'Inspect Letters' => sub {
        cmp_ok( scalar @{ $updated_game->letters }, '==', 5, 'Correct number of letters' );

        cmp_ok( $updated_game->letters->[0], '==',
            WordBrain::Letter->new( letter => 'l', row => 2, col => 0 ), 'Correct letter' );
        cmp_ok( $updated_game->letters->[1], '==',
            WordBrain::Letter->new( letter => 's', row => 1, col => 1 ), 'Correct letter' );
        cmp_ok( $updated_game->letters->[2], '==',
            WordBrain::Letter->new( letter => 'e', row => 1, col => 2 ), 'Correct letter' );
        cmp_ok( $updated_game->letters->[3], '==',
            WordBrain::Letter->new( letter => 'i', row => 2, col => 1 ), 'Correct letter' );
        cmp_ok( $updated_game->letters->[4], '==',
            WordBrain::Letter->new( letter => 'd', row => 2, col => 2 ), 'Correct letter' );
    };
};

done_testing;
