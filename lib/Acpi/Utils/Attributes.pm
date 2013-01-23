package Acpi::Utils::Attributes;
use strict;
use warnings;
use 5.010;
use Object::Tiny::XS qw( path device_n  );

sub attributes
{
	# Get the parameters from $dir 
	my $self = shift;
	my $device_n = $self->device_n;
	my $path 	 = $self->path;
	$device_n = 0 unless defined $device_n;
	my $dir = $path . $device_n;

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
