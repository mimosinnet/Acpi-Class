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
use Data::Dumper;
#}}}

my $battery 	 		= Acpi::Battery->new;
my $ac_online			= $battery->{'online'};
my $default_battery		= $battery->{'default_battery'};
my $battery_present		= $battery->global_values("present");
my $battery_energy_now	= $battery->global_values("energy_now");
my $battery_capacity	= $battery->global_values("capacity");
my $attributes 			= $battery->{'attributes'};

if ( $ac_online == 1 and $battery_present == 1 ) 
{
	say "Ac on and battery in use ";
	say "Energy now = ". $battery_energy_now ; 
	say "Capacity " . $battery_capacity ." %";	
} 
elsif ($battery_present) 
{
	say "Battery in use";
	say "Energy now = ". $battery_energy_now ; 
	say "Capacity " . $battery_capacity ." %";	
} 
else 
{ 
	say "Battery not present"; 
}

say "-" x 50 . "\n The attributes and values of battery $default_battery are: \n" . "-" x 50;
foreach my $attribute (@$attributes)
{
	my $value = $battery->value($attribute);
	say "Attribute $attribute = $value" if defined $value;
}

