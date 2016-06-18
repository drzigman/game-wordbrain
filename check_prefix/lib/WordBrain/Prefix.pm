package WordBrain::Prefix;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $args  = shift;

    if( !exists $args->{max_prefix_length} ) {
        $args->{max_prefix_length} = 8;
    }

    $args->{_prefix_cache} = $class->_load_words( $args->{max_prefix_length} );

    return bless $args, $class;
}

sub _load_words {
    my $class             = shift;
    my $max_prefix_length = shift;

    my $prefix_cache = { };

    my $file_path = substr( __FILE__, 0, length( __FILE__ ) - length( '/lib/WordBrain/Prefix.pm') ) . '/words.txt';

    open( my $words_fh, "<", $file_path ) or die "Unable to open words file";
    while( my $word = <$words_fh> ) {
        for( my $length = 1; $length <= $max_prefix_length; $length++ ) {
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

sub is_start_of_word {
    my $self   = shift;
    my $prefix = shift;

    return exists $self->{_prefix_cache}{ substr( $prefix, 0, $self->{max_prefix_length} ) };
}


1;
