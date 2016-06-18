#!/usr/bin/env perl

use strict;
no warnings;

my @LIBRARIES = ( 'moose/lib', 'perl_oop/lib', 'check_prefix/lib' );
my @LEVELS    = (
    { name => 'Ant 1',  playfield => 'takl', length_of_words_to_find => [ 4 ] },
    { name => 'Ant 2',  playfield => 'meaz', length_of_words_to_find => [ 4 ] },
    { name => 'Ant 3',  playfield => 'eson', length_of_words_to_find => [ 4 ] },
    { name => 'Ant 4',  playfield => 'cnhi', length_of_words_to_find => [ 4 ] },
    { name => 'Ant 5',  playfield => 'psuo', length_of_words_to_find => [ 4 ] },
    { name => 'Ant 6',  playfield => 'sopt', length_of_words_to_find => [ 4 ] },
    { name => 'Ant 7',  playfield => 'eaid', length_of_words_to_find => [ 4 ] },
    { name => 'Ant 8',  playfield => 'duck', length_of_words_to_find => [ 4 ] },
    { name => 'Ant 9',  playfield => 'tsla', length_of_words_to_find => [ 4 ] },
    { name => 'Ant 10', playfield => 'calm', length_of_words_to_find => [ 4 ] },


    { name => 'Spider 1',  playfield => 'amts', length_of_words_to_find => [ 4 ] },
    { name => 'Spider 2',  playfield => 'sfoa', length_of_words_to_find => [ 4 ] },
    { name => 'Spider 3',  playfield => 'post', length_of_words_to_find => [ 4 ] },
    { name => 'Spider 4',  playfield => 'tkei', length_of_words_to_find => [ 4 ] },
    { name => 'Spider 5',  playfield => 'kcro', length_of_words_to_find => [ 4 ] },
    { name => 'Spider 6',  playfield => 'gtoa', length_of_words_to_find => [ 4 ] },
    { name => 'Spider 7',  playfield => 'lias', length_of_words_to_find => [ 4 ] },
    { name => 'Spider 8',  playfield => 'sink', length_of_words_to_find => [ 4 ] },
    { name => 'Spider 9',  playfield => 'oavl', length_of_words_to_find => [ 4 ] },
    { name => 'Spider 10', playfield => 'htap', length_of_words_to_find => [ 4 ] },


    { name => 'Snail 1',  playfield => 'nhcaeefse', length_of_words_to_find => [qw( 3 6 )] },
    { name => 'Snail 2',  playfield => 'lselidlod', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Snail 3',  playfield => 'damraetbe', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Snail 4',  playfield => 'etnlictsa', length_of_words_to_find => [qw( 3 6 )] },
    { name => 'Snail 5',  playfield => 'lcfeeamon', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Snail 6',  playfield => 'bkoeoolbw', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Snail 7',  playfield => 'loenbyale', length_of_words_to_find => [qw( 2 7 )] },
    { name => 'Snail 8',  playfield => 'ezjzlaupm', length_of_words_to_find => [qw( 6 3 )] },
    { name => 'Snail 9',  playfield => 'dendlupag', length_of_words_to_find => [qw( 6 3 )] },
    { name => 'Snail 10', playfield => 'ootdardrc', length_of_words_to_find => [qw( 6 3 )] },
    { name => 'Snail 11', playfield => 'rahtapcpy', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Snail 12', playfield => 'cdbaelnde', length_of_words_to_find => [qw( 3 6 )] },
    { name => 'Snail 13', playfield => 'lksaoctep', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Snail 14', playfield => 'pfliyygst', length_of_words_to_find => [qw( 3 6 )] },
    { name => 'Snail 15', playfield => 'wlnhhieet', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Snail 16', playfield => 'estgiegnn', length_of_words_to_find => [qw( 6 3 )] },
    { name => 'Snail 17', playfield => 'nssakiils', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Snail 18', playfield => 'ttautrgge', length_of_words_to_find => [qw( 6 3 )] },
    { name => 'Snail 19', playfield => 'dckukakay', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Snail 20', playfield => 'eeicflnim', length_of_words_to_find => [qw( 4 5 )] },

    { name => 'Crab 1',  playfield => 'sdohglove', length_of_words_to_find => [qw( 3 6 )] },
    { name => 'Crab 2',  playfield => 'flfooirde', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Crab 3',  playfield => 'lluntkets', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Crab 4',  playfield => 'ekedeegch', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Crab 5',  playfield => 'waesnluff', length_of_words_to_find => [qw( 3 6 )] },
    { name => 'Crab 6',  playfield => 'skemttoen', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Crab 7',  playfield => 'nlmwoelel', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Crab 8',  playfield => 'gbytahrop', length_of_words_to_find => [qw( 3 6 )] },
    { name => 'Crab 9',  playfield => 'rphooteto', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Crab 10', playfield => 'eslsaktrd', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Crab 11', playfield => 'trroiaabb', length_of_words_to_find => [qw( 6 3 )] },
    { name => 'Crab 12', playfield => 'ipvntsach', length_of_words_to_find => [qw( 7 2 )] },
    { name => 'Crab 13', playfield => 'sthhusofi', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Crab 14', playfield => 'cosahudrt', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Crab 15', playfield => 'airhslcai', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Crab 16', playfield => 'heeoqrsua', length_of_words_to_find => [qw( 3 6 )] },
    { name => 'Crab 17', playfield => 'sadsobmer', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Crab 18', playfield => 'noeksforo', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Crab 19', playfield => 'tcsopesrw', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Crab 20', playfield => 'elrviofoo', length_of_words_to_find => [qw( 4 5 )] },

    { name => 'Frog 1',  playfield => 'fyesllick', length_of_words_to_find => [qw( 3 6 )] },
    { name => 'Frog 2',  playfield => 'enrdbails', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Frog 3',  playfield => 'lucgnaets', length_of_words_to_find => [qw( 3 6 )] },
    { name => 'Frog 4',  playfield => 'ullkkssoc', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Frog 5',  playfield => 'llasregsw', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Frog 6',  playfield => 'okemmaspl', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Frog 7',  playfield => 'dnctaalee', length_of_words_to_find => [qw( 3 6 )] },
    { name => 'Frog 8',  playfield => 'tetsgiohk', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Frog 9',  playfield => 'rgeatllbo', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Frog 10', playfield => 'larfrkoge', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Frog 11', playfield => 'lluamkles', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Frog 12', playfield => 'imclaraen', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Frog 13', playfield => 'tntrkrcau', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Frog 14', playfield => 'jnfaetapl', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Frog 15', playfield => 'getniwarh', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Frog 16', playfield => 'hferlrusi', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Frog 17', playfield => 'tbechtkii', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Frog 18', playfield => 'rfponiata', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Frog 19', playfield => 'hssisofkc', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Frog 20', playfield => 'okemshsni', length_of_words_to_find => [qw( 5 4 )] },

    { name => 'Turtle 1',  playfield => 'dnflacena', length_of_words_to_find => [qw( 6 3 )] },
    { name => 'Turtle 2',  playfield => 'dtriaeech', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Turtle 3',  playfield => 'mnlceiaim', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Turtle 4',  playfield => 'eimtilacn', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Turtle 5',  playfield => 'ltwslbrae', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Turtle 6',  playfield => 'hrcutaomt', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Turtle 7',  playfield => 'dteiymcep', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Turtle 8',  playfield => 'kbdlarime', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Turtle 9',  playfield => 'slawennag', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Turtle 10', playfield => 'pneaofksi', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Turtle 11', playfield => 'tjuassirg', length_of_words_to_find => [qw( 6 3 )] },
    { name => 'Turtle 12', playfield => 'haptumlos', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Turtle 13', playfield => 'ioelalnwb', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Turtle 14', playfield => 'bxearorbl', length_of_words_to_find => [qw( 3 6 )] },
    { name => 'Turtle 15', playfield => 'kabcetoms', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Turtle 16', playfield => 'eortkdlco', length_of_words_to_find => [qw( 6 3 )] },
    { name => 'Turtle 17', playfield => 'thchsainy', length_of_words_to_find => [qw( 5 4 )] },
    { name => 'Turtle 18', playfield => 'nndotaoir', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Turtle 19', playfield => 'hedsibarf', length_of_words_to_find => [qw( 4 5 )] },
    { name => 'Turtle 20', playfield => 'hcatredap', length_of_words_to_find => [qw( 5 4 )] },

    { name => 'Penguin 1',  playfield => 'latooltrgeeabugn', length_of_words_to_find => [qw( 4 6 6   )] },
    { name => 'Penguin 2',  playfield => 'tdacgrmaanenbubi', length_of_words_to_find => [qw( 3 3 5 5 )] },
    { name => 'Penguin 3',  playfield => 'nhynprmoroslutee', length_of_words_to_find => [qw( 6 5 5   )] },
    { name => 'Penguin 4',  playfield => 'fhfslsikarcegatn', length_of_words_to_find => [qw( 4 4 8   )] },
    { name => 'Penguin 5',  playfield => 'wenfheawogrsrcni', length_of_words_to_find => [qw( 3 3 4 6 )] },
    { name => 'Penguin 6',  playfield => 'tnytoppufommrije', length_of_words_to_find => [qw( 4 5 4 3 )] },
    { name => 'Penguin 7',  playfield => 'pirckathniidnosw', length_of_words_to_find => [qw( 6 5 5   )] },
    { name => 'Penguin 8',  playfield => 'dyaerpsiacktcren', length_of_words_to_find => [qw( 4 7 5   )] },
    { name => 'Penguin 9',  playfield => 'doorrapoaobulvcf', length_of_words_to_find => [qw( 8 4 4   )] },
    { name => 'Penguin 10', playfield => 'pstaatcaehdbmeer', length_of_words_to_find => [qw( 4 5 3 4 )] },

);

print "Level Name," . join(',', @LIBRARIES ) . "\n";

for my $level ( @LEVELS ) {
    print '"' . $level->{name} . '"';

    for my $library ( @LIBRARIES ) {
        print ",";

        my $args = " --playfield=\"$level->{playfield}\" ";
        for my $length_of_word_to_find (@{ $level->{length_of_words_to_find} }) {
            $args .= " --word-to-find=$length_of_word_to_find";
        }

        system("perl -I $library benchmark.pl $args");

    }
    print "\n";
}
