#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

use Game::WordBrain::Letter;
use Game::WordBrain::Word;
use Game::WordBrain::WordToFind;
use Game::WordBrain;

use Readonly;
Readonly my $WORD_TO_FIND => Game::WordBrain::WordToFind->new({ num_letters => 4 });

subtest 'Spellcheck Valid Word' => sub {
    my $word = Game::WordBrain::Word->new({
        letters => [
            Game::WordBrain::Letter->new({ letter => 't', row => 0, col => 0 }),
            Game::WordBrain::Letter->new({ letter => 'a', row => 0, col => 1 }),
            Game::WordBrain::Letter->new({ letter => 'l', row => 1, col => 0 }),
            Game::WordBrain::Letter->new({ letter => 'k', row => 1, col => 1 }),
        ]
    });

    my $game = Game::WordBrain->new({
        letters       => $word->{letters},
        words_to_find => [ $WORD_TO_FIND ],
    });

    ok( $game->spellcheck_word( $word ), 'Correctly identifies valid word' );
};

subtest 'Spellcheck Invalid Word' => sub {
    my $word = Game::WordBrain::Word->new({
        letters => [
            Game::WordBrain::Letter->new({ letter => 't', row => 0, col => 0 }),
            Game::WordBrain::Letter->new({ letter => 't', row => 0, col => 1 }),
            Game::WordBrain::Letter->new({ letter => 't', row => 1, col => 0 }),
            Game::WordBrain::Letter->new({ letter => 't', row => 1, col => 1 }),
        ]
    });

    my $game = Game::WordBrain->new({
        letters       => $word->{letters},
        words_to_find => [ $WORD_TO_FIND ],
    });


    ok( !$game->spellcheck_word( $word ), 'Correctly identifies invalid word' );
};

done_testing;
