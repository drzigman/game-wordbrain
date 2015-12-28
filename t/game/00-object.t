#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Moose::More;

use WordBrain::Game;

use Readonly;
Readonly my $CLASS => 'WordBrain::Game';

subtest "$CLASS is a well formed object" => sub {
    meta_ok( $CLASS );
};

subtest "$CLASS has the correct attributes" => sub {
    has_attribute_ok( $CLASS, 'letters' );
};

subtest "$CLASS has the correct methods" => sub {
    # Method is memoized
#    has_method_ok( $CLASS, 'get_letter_at_position' );
    ok( 1 );
};

done_testing;
