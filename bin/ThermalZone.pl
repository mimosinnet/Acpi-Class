#!/usr/bin/perl 

# Thermal Zone

# Modules {{{
use FindBin qw($Bin);
use lib "$Bin/../lib";
use 5.010;
use strict;
use warnings;
use Acpi::ThermalZone::Attributes;
use Acpi::ThermalZone;
use Data::Dumper;
#}}}

# Variables {{{
my $thermal 	= Acpi::ThermalZone->new;
my $attributes 	= Acpi::ThermalZone::Attributes::attributes();
# }}}

## Attributes recognized by your thermal zone: {{{
say "-" x 50 . "\n The attributes and values of your thermal zone are: \n" . "-" x 50;

foreach my $attr (keys %$attributes)
{
	my $value = $thermal->value($attr);
	say "$attr = $value"; 
}
say "-" x 50;
#}}}

# Get temperature: {{{
my $temperature = $thermal->value('temp');
say "Temperature = $temperature";
say "-" x 50;
#}}}

