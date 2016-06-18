#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

use WordBrain::Prefix;

subtest "Construct Prefix" => sub {
    my $prefix;
    lives_ok {
        $prefix = WordBrain::Prefix->new();
    } 'Lives through creation of Prefix';

    isa_ok( $prefix, 'WordBrain::Prefix' );
    cmp_ok( $prefix->{max_prefix_length}, '==', 8, 'Correct default max_prefix_length' );
    cmp_ok( $prefix->{_prefix_cache}{fro}, '==', 1, 'Something populated the _prefix_cache' );
};

done_testing;
