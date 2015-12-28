package WordBrain::Letter;

use strict;
use warnings;

use Moose;
use MooseX::StrictConstructor;
use namespace::autoclean;

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

__PACKAGE__->meta->make_immutable;
