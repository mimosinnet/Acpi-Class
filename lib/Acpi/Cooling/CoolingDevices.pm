package Acpi::Cooling::CoolingDevices; 

# use modules {{{
use 5.010;
use strict;
use warnings;
use feature 'state';
use Data::Dumper;
# }}}

# Cooling devices will be the same in the same session.
# we use state to not define it again.

sub new {#{{{
	my $class = shift;
	state $instance;
	if (! defined $instance) 
	{
		my $self = {
			'dir' => "/sys/class/thermal",
		};
		$instance = bless $self, $class;
	}
	return $instance;
}#}}}

sub cooling_devices #{{{
{ 
	my $self = shift;
	my $dir  = $self->{dir};
	opendir(my $cooling_device_dir, $dir) or die "Cannot open $dir : $!";
	my @cooling_devices;
	while(readdir($cooling_device_dir))
	{
		push @cooling_devices, $_ if ($_ =~ /cooling/);
	}
	closedir($cooling_device_dir);

	die "No cooling devices found" unless (scalar @cooling_devices > 0);
	return \@cooling_devices;
} #}}}

sub cooling_number #{{{
{ 
	my $self = shift;
	my $cooling_devices = $self->cooling_devices;
	my $cooling_number= @$cooling_devices;
	chomp $cooling_number;
	return $cooling_number;
} #}}}

1;
