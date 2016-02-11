#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Moose::More;

use WordBrain::Letter;

use Readonly;
Readonly my $CLASS => 'WordBrain::Letter';

subtest "$CLASS is a well formed object" => sub {
    meta_ok( $CLASS );
};

subtest "$CLASS has the correct attributes" => sub {
    has_attribute_ok( $CLASS, 'letter' );
    has_attribute_ok( $CLASS, 'row' );
    has_attribute_ok( $CLASS, 'col' );
};

subtest "$CLASS has the correct methods" => sub {
    has_method_ok( $CLASS, '_operator_equality' );
    has_method_ok( $CLASS, '_operator_stringify' );
};

done_testing;
