package WordBrain::Letter;

use strict;
use warnings;

use overload '==' => \&_operator_equality,
             '""' => \&_operator_stringify;

=head2 new

    my $letter = WordBrain::Letter->new({
        letter => 'a',
        row    => 1,
        col    => 3,
    });

=cut

sub new {
    my $class = shift;
    my $args  = shift;

    return bless $args, $class;
}

sub _operator_equality {
    my ( $a, $b ) = @_;

    if(    $a->{letter} eq $b->{letter}
        && $a->{row}    == $b->{row}
        && $a->{col}    == $b->{col} ) {

        return 1;
    }

    return 0;
}

sub _operator_stringify {
    my $self = shift;

    return $self->{letter};
}

1;
