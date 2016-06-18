#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

use WordBrain::Letter;
use WordBrain::Word;
use WordBrain::Game;

subtest '2x2' => sub {
    my $let_t = WordBrain::Letter->new({ letter => 't', row => 0, col => 0 });
    my $let_a = WordBrain::Letter->new({ letter => 'a', row => 0, col => 1 });
    my $let_l = WordBrain::Letter->new({ letter => 'l', row => 1, col => 0 });
    my $let_k = WordBrain::Letter->new({ letter => 'k', row => 1, col => 1 });

     my $game = WordBrain::Game->new({
        letters => [ $let_t, $let_a, $let_l, $let_k ],
        words_to_find => [ ],
    });

    inspect_found_words({
        letter         => $game->{letters}->[0],
        game           => $game,
        expected_words => [
            WordBrain::Word->new({ letters => [ $let_t, $let_a, ] }),
            WordBrain::Word->new({ letters => [ $let_t, $let_a, $let_l, ] }),
            WordBrain::Word->new({ letters => [ $let_t, $let_a, $let_l, $let_k, ] }),
            WordBrain::Word->new({ letters => [ $let_t, $let_a, $let_k, ] }),
            WordBrain::Word->new({ letters => [ $let_t, $let_a, $let_k, $let_l, ] }),
            WordBrain::Word->new({ letters => [ $let_t, $let_l, ] }),
            WordBrain::Word->new({ letters => [ $let_t, $let_l, $let_a, ] }),
            WordBrain::Word->new({ letters => [ $let_t, $let_l, $let_a, $let_k, ] }),
            WordBrain::Word->new({ letters => [ $let_t, $let_l, $let_k, ] }),
            WordBrain::Word->new({ letters => [ $let_t, $let_k, ] }),
            WordBrain::Word->new({ letters => [ $let_t, $let_k, $let_a, ] }),
            WordBrain::Word->new({ letters => [ $let_t, $let_k, $let_l, ] })
        ],
    });

    inspect_found_words({
        letter         => $game->{letters}->[1],
        game           => $game,
        expected_words => [
            WordBrain::Word->new({ letters => [ $let_a, $let_t, ] }),
            WordBrain::Word->new({ letters => [ $let_a, $let_t, $let_l, ] }),
            WordBrain::Word->new({ letters => [ $let_a, $let_t, $let_l, $let_k, ] }),
            WordBrain::Word->new({ letters => [ $let_a, $let_t, $let_k, ] }),
            WordBrain::Word->new({ letters => [ $let_a, $let_l, ] }),
            WordBrain::Word->new({ letters => [ $let_a, $let_l, $let_t, ] }),
            WordBrain::Word->new({ letters => [ $let_a, $let_l, $let_t, $let_k, ] }),
            WordBrain::Word->new({ letters => [ $let_a, $let_l, $let_k, ] }),
            WordBrain::Word->new({ letters => [ $let_a, $let_l, $let_k, $let_t, ] }),
            WordBrain::Word->new({ letters => [ $let_a, $let_k, ] }),
            WordBrain::Word->new({ letters => [ $let_a, $let_k, $let_t, ] }),
            WordBrain::Word->new({ letters => [ $let_a, $let_k, $let_t, $let_l, ] }),
            WordBrain::Word->new({ letters => [ $let_a, $let_k, $let_l, ] }),
        ],
    });

    inspect_found_words({
        letter         => $game->{letters}->[2],
        game           => $game,
        expected_words => [
            WordBrain::Word->new({ letters => [ $let_l, $let_t, ] }),
            WordBrain::Word->new({ letters => [ $let_l, $let_t, $let_a, ] }),
            WordBrain::Word->new({ letters => [ $let_l, $let_t, $let_k, ] }),
            WordBrain::Word->new({ letters => [ $let_l, $let_a, ] }),
            WordBrain::Word->new({ letters => [ $let_l, $let_a, $let_t, ] }),
            WordBrain::Word->new({ letters => [ $let_l, $let_a, $let_t, $let_k, ] }),
            WordBrain::Word->new({ letters => [ $let_l, $let_a, $let_k, ] }),
            WordBrain::Word->new({ letters => [ $let_l, $let_a, $let_k, $let_t, ] }),
            WordBrain::Word->new({ letters => [ $let_l, $let_k, ] }),
        ],
    });

    inspect_found_words({
        letter         => $game->{letters}->[3],
        game           => $game,
        expected_words => [
            WordBrain::Word->new({ letters => [ $let_k, $let_t, ] }),
            WordBrain::Word->new({ letters => [ $let_k, $let_t, $let_a, ] }),
            WordBrain::Word->new({ letters => [ $let_k, $let_t, $let_l, ] }),
            WordBrain::Word->new({ letters => [ $let_k, $let_a, ] }),
            WordBrain::Word->new({ letters => [ $let_k, $let_a, $let_t, ] }),
            WordBrain::Word->new({ letters => [ $let_k, $let_a, $let_t, $let_l, ] }),
            WordBrain::Word->new({ letters => [ $let_k, $let_a, $let_l, ] }),
            WordBrain::Word->new({ letters => [ $let_k, $let_a, $let_l, $let_t, ] }),
            WordBrain::Word->new({ letters => [ $let_k, $let_l, ] }),
            WordBrain::Word->new({ letters => [ $let_k, $let_l, $let_t, ] }),
            WordBrain::Word->new({ letters => [ $let_k, $let_l, $let_a, ] }),
            WordBrain::Word->new({ letters => [ $let_k, $let_l, $let_a, $let_t, ] }),
        ],
    });
};

done_testing;

sub inspect_found_words {
    my $args = shift;

    my $words;

    my $subtest_name = sprintf("Letter '%s' at %d x %d",
        $args->{letter}{letter}, $args->{letter}{row}, $args->{letter}{col} );
    subtest $subtest_name => sub {
        $words = $args->{game}->find_near_words({
            letter => $args->{letter},
        });

        # Used for constructing the expected words
=cut
        for my $word (@{ $words }) {
            print "WordBrain::Word->new({ letters => [";
            for my $letter (@{ $word->{letters} }) {
                printf ' $let_%s,', $letter->{letter};
            }
            print " ] }),\n";
        }
=cut


        cmp_ok( scalar @{ $words }, '==', scalar @{ $args->{expected_words} }, 'Correct number of words' );

        subtest 'Inspect Found Words' => sub {
            for( my $word_index = 0; $word_index < scalar @{ $words }; $word_index++ ) {
                my $found_word    = $words->[ $word_index ];
                my $expected_word = $args->{expected_words}->[ $word_index ];

                is_deeply( $found_word, $expected_word, 'Found ' . $expected_word );
            }
        };
    };

    return $words;
}

