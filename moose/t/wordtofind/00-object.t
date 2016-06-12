#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Moose::More;

use WordBrain::WordToFind;

use Readonly;
Readonly my $CLASS => 'WordBrain::WordToFind';

subtest "$CLASS is a well formed object" => sub {
    meta_ok( $CLASS );
};

subtest "$CLASS has the correct attributes" => sub {
    has_attribute_ok( $CLASS, 'num_letters' );
};

done_testing;
