#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: Values.pl
#
#        USAGE: ./Values.pl  
#
#  DESCRIPTION: See if we can get the values
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 10/01/13 22:28:32
#     REVISION: ---
#===============================================================================

use FindBin qw($Bin);
use lib "$Bin/lib";
use strict;
use warnings;
use utf8;
use Acpi::Batt;
use Moose;

my $a = Acpi::Batt->new(dir => "/sys/class/power_supply/BAT0/uevent");
#my $b = $a->model_name;
# print "$b \n";

my $meta = Class::MOP::Class->initialize("Acpi::Battery::Values");

for my $attr ( $meta->get_all_attributes ) {
	my $an = $attr->name;
	my $value = $a->$an;
    print "$an = $value \n";
}
