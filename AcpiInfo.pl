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
use 5.010;
use Acpi::Info;
use Moose;


my $i1 = Acpi::Info->new(file => '/sys/class/power_supply/BAT1/uevent');

my $a = Acpi::Info->new(file => "/sys/class/power_supply/BAT1/uevent");
# my $a = Acpi::Battery::Values->new();
my $b = $a->model_name;
print "$b \n";

my $meta = Class::MOP::Class->initialize("Acpi::Info");

    say "----";
    for my $attr ($i1->meta->get_all_attributes) {
        my $aname = $attr->name;
        next if $aname =~ /^_/;
        say $aname, " = ", $i1->$aname;
    }

