#!/usr/bin/perl 
#===============================================================================
#
#         FILE: AcpiBattery.pl
#
#        USAGE: ./AcpiBattery.pl  
#
#  DESCRIPTION: Example of how acpi-battery information
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

# Modules {{{
use FindBin qw($Bin);
use lib "$Bin/../lib";
use 5.010;
use strict;
use warnings;
use Data::Dumper;
use Acpi::Battery;
use Acpi::Battery::Values;
use Acpi::Battery::Batteries;
use Acpi::Battery::Attributes;
#}}}

my $battery = Acpi::Battery->new();
my $batts = $battery->batts_number;

# Attributes recognized by your first battery: {{{
say "-" x 50 . "
Attributes recognized by your battery
" . "-" x 40 . "
To get the attribute:
	" . "-" x 40 . "
	" . 'my $batt = Acpi::Battery->new();
	my $attribute = $batt->BAT_atrribute;
	say "The value of attribute BAT_attribute is $attribute";';

my $attributes =  Acpi::Battery::Attributes->new()->attributes;
my $bat0 = Acpi::Battery::Batteries->new()->batteries->[0];
say "-" x 50 . "\n The attributes and values of battery $bat0 are: \n" . "-" x 50;
foreach (@$attributes)
{
	my $att = $bat0 . "_" . $_;
	my $value = $battery->$att;
	say "Attribute $_ = $value";
}
say "-" x 50;
#}}}

# Number of Batteries (ArrayRef): {{{
say "Batteries identified in your system (ArrayRef): ";
my @attributes_ArrayRef = qw(bats_names);
foreach (@attributes_ArrayRef) 
{
	my $value = $battery->$_;
	say "Attribute $_: ";
	foreach my $i (@$value)
	{
		say "... Value $i";
	}
}
say "-" x 50;
#}}}

# Get serial number of first battery: {{{
my $model_name_attribute = $bat0 . "_model_name";
my $model_name = $battery->$model_name_attribute;
say "Model name of $bat0 = $model_name";
say "-" x 50;
#}}}

my @global_info = qw(energy_full energy_now capacity ac_online batts_number present);
say "Information for all batteries: ";
print "$_ " foreach (@global_info);
print "\n" . "-" x 40 . "\n";
foreach (@global_info) 
{
	my $value = $battery->$_;
	say "." x 5 . " $_ = $value";
}
say "-" x 50;

