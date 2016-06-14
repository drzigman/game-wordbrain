package WordBrain::Word;

use strict;
use warnings;

use overload '""' => \&_operator_stringify;

use WordBrain::Letter;

=head2 new

    my $letter = WordBrain::Letter->...
    my $word   = WordBrain::Word->new({
        letters => [ $letter ]
    });

=cut

sub new {
    my $class = shift;
    my $args  = shift;

    return bless $args, $class;
}

sub word {
    my $self = shift;

    my $word;
    for my $letter (@{ $self->{letters} }) {
        $word .= $letter->{letter};
    }

    return $word;
}

sub _operator_stringify {
    my $word = shift;

    return $word->word;
}

1;
