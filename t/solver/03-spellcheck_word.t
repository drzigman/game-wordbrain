#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

use WordBrain::Letter;
use WordBrain::Word;
use WordBrain::Solver qw( spellcheck_word );

subtest 'Spellcheck Valid Word' => sub {
    my $word = WordBrain::Word->new(
        letters => [
            WordBrain::Letter->new( letter => 't', row => 0, col => 0 ),
            WordBrain::Letter->new( letter => 'a', row => 0, col => 1 ),
            WordBrain::Letter->new( letter => 'l', row => 1, col => 0 ),
            WordBrain::Letter->new( letter => 'k', row => 1, col => 1 ),
        ]
    );

    ok( spellcheck_word( $word ), 'Correctly identifies valid word' );
};

subtest 'Spellcheck Invalid Word' => sub {
    my $word = WordBrain::Word->new(
        letters => [
            WordBrain::Letter->new( letter => 't', row => 0, col => 0 ),
            WordBrain::Letter->new( letter => 't', row => 0, col => 1 ),
            WordBrain::Letter->new( letter => 't', row => 1, col => 0 ),
            WordBrain::Letter->new( letter => 't', row => 1, col => 1 ),
        ]
    );

    ok( !spellcheck_word( $word ), 'Correctly identifies invalid word' );
};

done_testing;
