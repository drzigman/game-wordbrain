#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

use WordBrain::Letter;
use WordBrain::Word;
use WordBrain::Game;

subtest 'Spellcheck Valid Word' => sub {
    my $word = WordBrain::Word->new({
        letters => [
            WordBrain::Letter->new({ letter => 't', row => 0, col => 0 }),
            WordBrain::Letter->new({ letter => 'a', row => 0, col => 1 }),
            WordBrain::Letter->new({ letter => 'l', row => 1, col => 0 }),
            WordBrain::Letter->new({ letter => 'k', row => 1, col => 1 }),
        ]
    });

    my $game = WordBrain::Game->new({
        letters       => [ ],
        words_to_find => [ ],
    });

    ok( $game->spellcheck_word( $word ), 'Correctly identifies valid word' );
};

subtest 'Spellcheck Invalid Word' => sub {
    my $word = WordBrain::Word->new({
        letters => [
            WordBrain::Letter->new({ letter => 't', row => 0, col => 0 }),
            WordBrain::Letter->new({ letter => 't', row => 0, col => 1 }),
            WordBrain::Letter->new({ letter => 't', row => 1, col => 0 }),
            WordBrain::Letter->new({ letter => 't', row => 1, col => 1 }),
        ]
    });

    my $game = WordBrain::Game->new({
        letters       => [ ],
        words_to_find => [ ],
    });


    ok( !$game->spellcheck_word( $word ), 'Correctly identifies invalid word' );
};

done_testing;
