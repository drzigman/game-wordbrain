package WordBrain::WordToFind;

use strict;
use warnings;

use Moose;
use MooseX::StrictConstructor;
use namespace::autoclean;

use WordBrain::Types qw( PositiveInt );

has num_letters => (
    is       => 'ro',
    isa      => PositiveInt,
    required => 1,
);

__PACKAGE__->meta->make_immutable;
1;
