# Attributes that the battery recognises
package Acpi::Battery::Attributes;
use strict;
use warnings;
use 5.010;
use Acpi::Battery::Batteries;

sub attributes
{
	my $device_n = shift;
	# The parameters of both batteries should be the same
	$device_n = Acpi::Battery::Batteries->new()->batteries->[0] unless defined $device_n;
	my $file = "/sys/class/power_supply/BAT$device_n/uevent";

	my $content = do
	{
			local @ARGV = $file;
			local $/    = <ARGV>;
	};

	my @attrs = $content =~ /^POWER_SUPPLY_(\w+)=.*/mg;
	my @attributes = map lc($_), @attrs;
	return \@attributes;
}

1;
