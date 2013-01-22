package Acpi::Cooling::Attributes;
use strict;
use warnings;
use 5.010;

sub attributes
{
	# Get the parameters from $dir 
	my $cooling_device_n = shift;
	$cooling_device_n = 0 unless defined $cooling_device_n;
	my $dir = "/sys/class/thermal/cooling_device$cooling_device_n";

	opendir (my $cooling_device, $dir)  or die "Cannot open $dir : $!";
	my %attributes;
	while (readdir($cooling_device))
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
