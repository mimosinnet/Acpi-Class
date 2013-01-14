#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: Batteries.pl
#
#        USAGE: ./Batteries.pl  
#
#  DESCRIPTION: get batteries present
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), 
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 12/01/13 13:40:46
#     REVISION: ---
#===============================================================================

use FindBin qw($Bin);
use lib "$Bin/../../../lib";
use strict;
use warnings;
use utf8;
use 5.010;
use Acpi::Battery::Batteries;
use Test::More;

my $batt = Acpi::Battery::Batteries->new();
my $batts = $batt->batteries;
my $adaptor = $batt->adaptor;
my $online = $batt->on_line;

ok ( $adaptor  =~ /\w/, "The ac_adaptor is: $adaptor" );
ok ( $online =~ /[01]/, "The online status of $adaptor is $online " );

foreach (@$batts) 
{
	ok ( $_ =~ /\w/, "Battery $_ has been identified" );
}

done_testing();
