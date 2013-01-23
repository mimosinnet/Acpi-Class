package Acpi::ThermalZone::Attributes;
use strict;
use warnings;
use 5.010;

sub attributes
{
	# Get the parameters from /sys/class/thermal/thermal_zone0
	my $dir = "/sys/class/thermal/thermal_zone0";

	opendir (my $thermal_zone, $dir)  or die "Cannot open $dir : $!";
	my %attributes;
	while (readdir($thermal_zone))
	{
		if (-f "$dir/$_")
		{
			my $content = do 
			{
				local @ARGV = "$dir/$_";
				local $/    = <ARGV>;
			};
			chomp $content;
			$attributes{$_} = $content;
		}
	}

	return \%attributes;
}

1;

