package Game::WordBrain::Prefix;

use strict;
use warnings;

use Cwd qw( abs_path );

# VERSION
# ABSTRACT: Creates a Cache of Valid Word Prefixes

=head1 NAME

WordBrain::Prefix - Creates a Cache of Valid Word Prefixes

=head1 SYNOPSIS

    # Create new Prefix Cache
    my $prefix = Game::WordBrain::Prefix->new({
        max_prefix_length => 5,                     # Optional
        word_list         => '/path/to/wordlist',   # Optional
    });

    # Test if a string could be the start of a word
    my $start_of_word = 'fla';
    if( $prefix->is_start_of_word( $start_of_word ) ) {
        print "Could be a word...";
    }
    else {
        print "Nope, no way this is going to be a word.";
    }


=head1 DESCRIPTION

L<Game::WordBrain::Prefix> is the largest speedup afforded to the L<Game::WordBrain>->solve method.  It works by reading in a wordlist and using it to construct a hash of valid word prefixes.  As an example, let's take the word "flag"

    {
        'f'    => 1,
        'fl'   => 1,
        'fla'  => 1,
        'flag' => 1,
    }

By creating this L<Game::WordBrain> is able to check if the current path being walked ( collection of L<Game::WordBrain::Letter>s ) could possibly ever be a real word.  By leverage the fact that, for example, no word in the english language starts with 'flaga' we can short circuit and abandon a path that will not lead to a solution sa fast as possible.

=head1 ATTRIBUTES

=head2 max_prefix_length

The length of the prefixes to build.  This should equal the max L<Game::WordBrain::WordToFind>->{num_letters}.  If not provided, it defaults to 8.

Keep in mind, the larger this value the longer the I<spin up> time needed in order to run the solver.

=head2 word_list

Path to a new line delimited word_list.  If not provided, the wordlist provided with this distrubtion will be used.

=head1 METHODS

=head2 new

    my $prefix = Game::WordBrain::Prefix->new({
        max_prefix_length => 5,                     # Optional
        word_list         => '/path/to/wordlist',   # Optional
    });

If the max_prefix length is not specified it will default to 8.  If no word_list is specified then the bundled wordlist will be used.

Returns an instance of L<Game::WordBrain::Prefix>

=cut

sub new {
    my $class = shift;
    my $args  = shift;

    if( !exists $args->{max_prefix_length} ) {
        $args->{max_prefix_length} = 8;
    }

    if( !exists $args->{word_list} ) {
        my $my_abs_path    = abs_path( __FILE__ );
        $args->{word_list} = substr( $my_abs_path, 0, length( $my_abs_path ) - length( '/lib/Game/WordBrain/Prefix.pm') ) . '/words.txt';
    }

    $args->{_prefix_cache} = $class->_load_words({
        max_prefix_length => $args->{max_prefix_length},
        word_list         => $args->{word_list},
    });

    return bless $args, $class;
}

sub _load_words {
    my $class = shift;
    my $args  = shift;

    my $prefix_cache = { };

    open( my $words_fh, "<", $args->{word_list} ) or die "Unable to open words file";
    while( my $word = <$words_fh> ) {
        for( my $length = 1; $length <= $args->{max_prefix_length}; $length++ ) {
            if( length( $word ) >= $length ) {
                $prefix_cache->{ substr( $word, 0, $length ) } = 1;
            }
            else {
                last;
            }
        }
    }

    return $prefix_cache;
}

=head2 is_start_of_word

    my $prefix        = Game::WordBrain::Prefix->...;
    my $start_of_word = 'fla';

    if( $prefix->is_start_of_word( $start_of_word ) ) {
        print "Could be a word...";
    }
    else {
        print "Nope, no way this is going to be a word.";
    }

Given a string, will check to seeif there are any words in the provided word_list that start with this string.  If there are ( meaning this could become a real word at some point ) a truthy value is returned.  If not, a falsey value is returned.

=cut

sub is_start_of_word {
    my $self   = shift;
    my $prefix = shift;

    return exists $self->{_prefix_cache}{ substr( $prefix, 0, $self->{max_prefix_length} ) };
}


1;
