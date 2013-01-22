package Acpi::Utils::Devices; 

# use modules {{{
use 5.010;
use strict;
use warnings;
use Object::Tiny::XS qw{ dir pattern };
use Data::Dumper;
# }}}


sub devices #{{{
{ 
	my $self = shift;
	my $dir     = $self->dir;
	my $pattern = $self->pattern;
	opendir(my $device_dir, $dir) or die "Cannot open $dir : $!";
	my @devices;
	while(readdir($device_dir))
	{
		push @devices, $_ if ($_ =~ /$pattern/);
	}
	closedir($device_dir);

	die "No cooling devices found" unless (scalar @devices > 0);
	return \@devices;
} #}}}

sub number #{{{
{ 
	my $self = shift;
	my $devices = $self->devices;
	my $number= @$devices;
	chomp $number;
	return $number;
} #}}}

1;
