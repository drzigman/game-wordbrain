package WordBrain::Word;

use strict;
use warnings;

use Moose;
use MooseX::StrictConstructor;
use namespace::autoclean;

use overload '""' => \&_operator_stringify;

use WordBrain::Types qw( Letters );

use WordBrain::Letter;

has letters => (
    is       => 'ro',
    isa      => Letters,
    required => 1,
);

sub word {
    my $self = shift;

    my $word;
    for my $letter (@{ $self->letters }) {
        $word .= $letter->letter;
    }

    return $word;
}

sub _operator_stringify {
    my $word = shift;

    return $word->word;
}

__PACKAGE__->meta->make_immutable;
1;
