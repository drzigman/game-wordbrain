package WordBrain::Types;

use strict;
use warnings;

use MooseX::Types -declare => [qw(
    ArrayRef
    Char
    Int
    HashRef
    NaturalInt
    Str

    Game
    Letter
    Letters
)];

use Moose::Util::TypeConstraints;
use MooseX::Types::Moose
    Int  => { -as => 'MooseInt' },
    Str  => { -as => 'MooseStr' },
    ArrayRef => { -as => 'MooseArrayRef' },
    HashRef  => { -as => 'MooseHashRef' };

subtype Int, as MooseInt;
subtype Str, as MooseStr;
subtype ArrayRef, as MooseArrayRef;
subtype HashRef, as MooseHashRef;

subtype Char, as MooseStr,
    where { length( $_ ) == 1 },
    message { "'$_' is not a valid char" };

subtype NaturalInt, as MooseInt;
    where { $_ >= 0 },
    message { "'$_' is not a valid natural integer" };

class_type Game,   { class => 'WordBrain::Game' };
class_type Letter, { class => 'WordBrain::Letter' };
coerce Letter, from HashRef,
    via { WordBrain::Letter->new( $_ ) };

subtype Letters, as ArrayRef[Letter];
coerce Letters, from ArrayRef[HashRef],
    via { [ map { WordBrain::Letter->new( $_ ) } @{ $_ } ] };

1;
