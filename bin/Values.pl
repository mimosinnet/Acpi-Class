#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: Values.pl
#
#  DESCRIPTION: Shows all battery values, even if they are not present in the 
#  				information  provided by uevent.
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

# Packages {{{
use FindBin qw($Bin);
use lib "$Bin/../lib";
use strict;
use warnings;
use utf8;
use 5.010;
use Acpi::Battery::Values;
use Acpi::Battery::Batteries;
use Moose;
#}}}

# Definition of Variables {{{
my $bat = Acpi::Battery::Batteries->new()->batteries->[0];
my $uevent_file = "/sys/class/power_supply/$bat/uevent";
my $a = Acpi::Battery::Values->new( file => $uevent_file );
my $meta = Class::MOP::Class->initialize("Acpi::Battery::Values");
#}}}

# Get the atrributes {{{
for my $attr ( $meta->get_all_attributes ) {
	my $an = $attr->name;
	next if $an =~ /^_/;                        # Next if attribute is private
	my $value = $a->$an;
    say "$an = $value";
}
#}}}
