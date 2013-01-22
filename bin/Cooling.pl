#!/usr/bin/perl 

# Modules {{{
use FindBin qw($Bin);
use lib "$Bin/../lib";
use 5.010;
use strict;
use warnings;
use Acpi::Cooling;
# use Acpi::Battery::Values;
use Acpi::Cooling::CoolingDevices;
use Acpi::Cooling::Attributes;
use Data::Dumper;
#}}}


# Variables {{{
my $cooling					= Acpi::Cooling->new;
my $cooling_device			= Acpi::Cooling::CoolingDevices->new;
my $name_first_cooling 		= $cooling_device->cooling_devices->[0];
my $cooling_devices 		= $cooling_device->cooling_devices;
my $cooling_number			= $cooling_device->cooling_number;
my $attributes 				= Acpi::Cooling::Attributes::attributes();
#my $first_battery 		= Acpi::Battery->new( battery => $name_first_battery);
# }}}


## Number of Cooling Devices (ArrayRef): {{{
say "In your system there is/are $cooling_number cooling devices:";
foreach (@$cooling_devices) { print " $_";}
print "\n";
#}}}

# Attributes recognized by your cooling devices {{{
for (my $i = 0; $i < $cooling_number; $i++)
{
	say "-" x 50 . "\n The attributes and values of cooling device $i are:";
	my $cooling = Acpi::Cooling->new( $i );
	foreach my $attr (keys %$attributes)
	{
		my $value = $cooling->value($attr); 
		say "$attr = $value" if defined $value;
	}
}
##}}}
#

## Get model name of your first battery: {{{
#my $model_name = $first_battery->value('model_name');
#say "Model name of $name_first_battery = $model_name";
#say "-" x 50;
##}}}
#
## Gives global information on selected values {{{
#my @global_info = qw(energy_full energy_now charge_full charge_now capacity present);
#say "Information for all batteries: ";
#print "$_ " foreach (@global_info);
#print "\n" . "-" x 40 . "\n";
#my $global = Acpi::Battery->new;
#foreach my $attribute (@global_info) 
#{
#	my $value = $global->global_values($attribute);
#	say "." x 5 . " $attribute = $value";
#}
#say "-" x 50;
## }}}
