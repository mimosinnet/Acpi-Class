#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: Example.pl
#
#        USAGE: ./Example.pl  
#
#  DESCRIPTION: Example on how to use the module
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), 
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 15/01/13 23:59:38
#     REVISION: ---
#===============================================================================

use FindBin qw($Bin);
use lib "$Bin/../lib";
use strict;
use warnings;
use utf8;
use 5.010;
use Acpi::Battery;

my $battery = Acpi::Battery->new;

if ( $battery->ac_online == 0 and $battery->present == 1 )
{
	say "Ac on and battery in use ";
	say "Energy/power now = ". $battery->energy_now ; 
	say "Capacity " . $battery->capacity ." %";	
}
elsif ($battery->present)
{
	say "Battery in use";
	say "Energy/power now = ". $battery->energy_now ; 
	say "Capacity " . $battery->capacity ." %";	
}
	else
{
	say "Battery not present";
}

