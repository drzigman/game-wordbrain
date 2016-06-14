package WordBrain::Solution;

use strict;
use warnings;

use WordBrain::Word;

=head2 new

    my $word     = WordBrain::Word->...;
    my $solution = WordBrain::Solution->new({
        words => [ $word ]
    });

=cut

sub new {
    my $class = shift;
    my $args  = shift;

    return bless $args, $class;
}

1;
