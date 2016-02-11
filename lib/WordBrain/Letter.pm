package WordBrain::Letter;

use strict;
use warnings;

use Moose;
use MooseX::StrictConstructor;
use namespace::autoclean;

use overload '==' => \&_operator_equality,
             '""' => \&_operator_stringify;

use WordBrain::Types qw( Char NaturalInt );

has letter => (
    is       => 'ro',
    isa      => Char,
    required => 1,
);

has row => (
    is       => 'ro',
    isa      => NaturalInt,
    required => 1,
);

has col => (
    is       => 'ro',
    isa      => NaturalInt,
    required => 1,
);

sub _operator_equality {
    my ( $a, $b ) = @_;

    if(    $a->letter eq $b->letter
        && $a->row    == $b->row
        && $a->col    == $b->col ) {

        return 1;
    }

    return 0;
}

sub _operator_stringify {
    my $letter = shift;

    return $letter->letter;
}

__PACKAGE__->meta->make_immutable;
