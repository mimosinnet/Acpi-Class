#!/usr/bin/perl 
#===============================================================================
#  Information from Acpi::Battery 
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

# Variables {{{
my $batteries 			= Acpi::Battery::Batteries->new;
my $name_first_battery 	= $batteries->batteries->[0];
my $batteries_names		= $batteries->batteries;
my $attributes 			= Acpi::Battery::Attributes->new()->attributes;
my $first_battery 		= Acpi::Battery->new( battery => $name_first_battery);
# }}}

# Attributes recognized by your first battery: {{{
say "-" x 50;
say "Your first battery is: $name_first_battery";
say "-" x 50 . "\n The attributes and values of battery $name_first_battery are: \n" . "-" x 50;
foreach (@$attributes)
{
	my $value = $first_battery->$_;
	say "$_ = $value";
}
say "-" x 50;
#}}}

# Number of Batteries (ArrayRef): {{{
my $number_of_batteries = $batteries->batts_number;
print "In your system there is/are $number_of_batteries batteries: ";
foreach (@$batteries_names) { print " $_";}
say "\n" . "-" x 50;
#}}}

# Get model name of your first battery: {{{
my $model_name = $first_battery->model_name;
say "Model name of $name_first_battery = $model_name";
say "-" x 50;
#}}}

# Gives global information on selected values {{{
my @global_info = qw(charge_full charge_now present);
say "Information for all batteries: ";
print "$_ " foreach (@global_info);
print "\n" . "-" x 40 . "\n";
my $global = Acpi::Battery->new;
foreach my $attribute (@global_info) 
{
	my $value = $global->global_values($attribute);
	say "." x 5 . " $attribute = $value";
}
say "-" x 50;
# }}}
