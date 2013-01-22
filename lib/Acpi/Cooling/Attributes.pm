package Acpi::Cooling::Attributes;
use strict;
use warnings;
use 5.010;

sub attributes
{
	# Get the parameters from $dir 
	my $device_n = shift;
	$device_n = 0 unless defined $device_n;
	my $dir = "/sys/class/thermal/cooling_device$device_n";

	opendir (my $device, $dir)  or die "Cannot open $dir : $!";
	my %attributes;
	while (readdir($device))
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
