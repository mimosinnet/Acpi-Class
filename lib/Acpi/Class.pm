package Acpi::Class;

# Modules {{{
use 5.010;
use strict;
use warnings;
use Acpi::Utils::Devices_1;
use Data::Dumper;
# }}}

# set version. {{{
# See: http://www.dagolden.com/index.php/369/version-numbers-should-be-boring/
our $VERSION = "0.100";
$VERSION = eval $VERSION;
#}}}

sub new {
    my ($class, $device_n) = @_;
	my $devices = Acpi::Utils::Devices_1->new( dir => "/sys/class", pattern => qr/\w/ );
	$device_n = ($devices->devices->[0]) unless defined $device_n;
    my($self) = {
		'device_n' 	 => $device_n,
		'devices'    => $devices->devices,
		'number'	 => $devices->number,
	};
 
    bless $self, $class;
    return $self;
}

sub devices
{
	my ($class, $device) = @_;
	my $elements = Acpi::Utils::Devices_1->new( dir => "/sys/class/$device", pattern => qr/\w/ )->devices;
	return \@$elements;
}


1;
 

