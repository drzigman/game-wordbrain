#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Moose::More;

use WordBrain::Word;

use Readonly;
Readonly my $CLASS => 'WordBrain::Word';

subtest "$CLASS is a well formed object" => sub {
    meta_ok( $CLASS );
};

subtest "$CLASS has the correct attributes" => sub {
    has_attribute_ok( $CLASS, 'letters' );
};

subtest "$CLASS has the correct methods" => sub {
    has_method_ok( $CLASS, 'word' );
    has_method_ok( $CLASS, '_operator_stringify' );
};

done_testing;
