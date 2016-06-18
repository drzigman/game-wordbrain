package WordBrain::WordToFind;

use strict;
use warnings;

=head2 new

    my $word_to_find = WordBrain::WordToFind->new({
        num_letters => 1
    });

=cut

sub new {
    my $class = shift;
    my $args  = shift;

    return bless $args, $class;
}

1;
