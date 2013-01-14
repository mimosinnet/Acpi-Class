#!/usr/bin/perl 
#===============================================================================
#
#         FILE: AcpiBattery.pl
#
#        USAGE: ./AcpiBattery.pl  
#
#  DESCRIPTION: Com funciona el mòdul Acpi::Battery
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), mimosinnet@ningunlugar.org
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 07/01/13 17:00:22
#     REVISION: ---
#===============================================================================

use FindBin qw($Bin);
use lib "$Bin/../lib";
use 5.010;

use strict;
use warnings;

# Fem servir la que hem creat nosaltres
use Acpi::Battery;

my $battery = Acpi::Battery->new;

if ($battery->batteryOnLine) {
    say "Battery online";
    say "Charge: " . $battery->getCharge."% "; 
}

else{

	say "Battery offline";
    say "Charge: " . $battery->getCharge."% "; 

}
