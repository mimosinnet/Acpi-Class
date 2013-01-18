#!/usr/bin/env perl 
#===============================================================================
#  DESCRIPTION: Example on how to use the module
#===============================================================================

# Modules {{{
use FindBin qw($Bin);
use lib "$Bin/../lib";
use 5.010;
use strict;
use warnings;
use Acpi::Battery;
use Acpi::Battery::Values;
use Acpi::Battery::Batteries;
use Acpi::Battery::Attributes;
#}}}

my $ac_online			= Acpi::Battery::Batteries->new->on_line;
my $battery 	 		= Acpi::Battery->new;
my $battery_present		= $battery->global_values("present");
my $battery_energy_now	= $battery->global_values("energy_now");
my $battery_capacity	= $battery->global_values("capacity");
if ( $ac_online == 1 and $battery_present == 1 ) {
	say "Ac on and battery in use ";
	say "Energy now = ". $battery_energy_now ; 
	say "Capacity " . $battery_capacity ." %";	
} elsif ($battery_present) {
	say "Battery in use";
	say "Energy now = ". $battery_energy_now ; 
	say "Capacity " . $battery_capacity ." %";	
} else { say "Battery not present"; }

	# Get the attributes:
	my $attributes =  Acpi::Battery::Attributes->new()->attributes;
	# Name of the first battery:
	my $bat0 = Acpi::Battery::Batteries->new()->batteries->[0];
	say "-" x 50 . "\n The attributes and values of battery $bat0 are: \n" . "-" x 50;
	foreach my $attribute (@$attributes)
	{
		my $value = $battery->$attribute;
		say "Attribute $attribute = $value";
	}

