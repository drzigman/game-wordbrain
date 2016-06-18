#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

use WordBrain::Letter;
use WordBrain::Word;

subtest 'Stringify' => sub {
    my @letters;
    for my $letter (qw( a b c d e f )) {
        push @letters, WordBrain::Letter->new({
            letter => $letter,
            row    => 1,
            col    => 1,
        });
    }

    my $word = WordBrain::Word->new({
        letters => \@letters,
    });

    cmp_ok( "$word", 'eq', 'abcdef', 'Correct word' );
};

done_testing;
