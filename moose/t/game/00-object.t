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
    has_attribute_ok( $CLASS, 'words_to_find' );
    has_attribute_ok( $CLASS, 'solutions' );
};

subtest "$CLASS has the correct methods" => sub {
    has_method_ok( $CLASS, 'solve' );
    has_method_ok( $CLASS, 'construct_game_without_word' );
    has_method_ok( $CLASS, 'get_letter_at_position' );
};

done_testing;
