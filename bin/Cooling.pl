#!/usr/bin/perl 

# Modules {{{
use FindBin qw($Bin);
use lib "$Bin/../lib";
use 5.010;
use strict;
use warnings;
use Acpi::Cooling;
# use Acpi::Battery::Values;
use Data::Dumper;
#}}}

# Variables {{{
my $cooling					= Acpi::Cooling->new;
my $name_first_cooling 		= $cooling->{devices}->[0];
my $cooling_devices 		= $cooling->{devices};
my $cooling_number			= $cooling->{number};
my $attributes 				= $cooling->{attributes};
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
#}}}

