package WordBrain::Game;

use strict;
use warnings;

use Moose;
use MooseX::Params::Validate;
use MooseX::StrictConstructor;
use namespace::autoclean;

use WordBrain::Types qw( Letters NaturalInt );

use List::Util qw( first );

use Memoize;
memoize( 'get_letter_at_position' );

has letters => (
    is       => 'ro',
    isa      => Letters,
    required => 1,
    coerce   => 1,
);

sub get_letter_at_position {
    my $self     = shift;
    my ( %args ) = validated_hash(
        \@_,
        row => { isa => NaturalInt },
        col => { isa => NaturalInt },
    );

    return first {
           $_->row == $args{row}
        && $_->col == $args{col}
    } @{ $self->letters };
}

__PACKAGE__->meta->make_immutable;

1;
