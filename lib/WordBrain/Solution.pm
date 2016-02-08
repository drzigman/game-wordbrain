package WordBrain::Solution;

use strict;
use warnings;

use Moose;
use MooseX::StrictConstructor;
use namespace::autoclean;

use WordBrain::Types qw( Words );

has words => (
    is       => 'ro',
    isa      => Words,
    required => 1,
);

__PACKAGE__->meta->make_immutable;
1;
