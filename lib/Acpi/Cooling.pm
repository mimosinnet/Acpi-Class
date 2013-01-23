package Acpi::Cooling;

# Modules {{{
use 5.010;
use strict;
use warnings;
use Acpi::Utils::Devices;
use Acpi::Utils::Attributes;
use Data::Dumper;
# }}}

# set version. {{{
# See: http://www.dagolden.com/index.php/369/version-numbers-should-be-boring/
our $VERSION = "0.100";
$VERSION = eval $VERSION;
#}}}

sub new {
    my ($class, $device_n) = @_;
	$device_n = 0 unless defined $device_n;
	my $devices = Acpi::Utils::Devices->new( dir => "/sys/class/thermal", pattern => "cooling_device" );
    my($self) = {
		'device_n' 	 => $device_n,
		'devices'    => $devices->devices,
		'number'	 => $devices->number,
		'attributes' => Acpi::Utils::Attributes->new( # HashRef
		   					'path' => "/sys/class/thermal/cooling_device", 
							'device_n' => $device_n,
   						)->attributes,
	};
 
    bless $self, $class;
    return $self;
}

sub value 							# get value {{{
{
	my ($self, $attribute) = @_;
	my $number = $self->{number};
	my $device_n = $self->{device_n};
	my $attributes = $self->{attributes};
	$device_n = 0 unless defined $device_n;
	die "Cooling device $device_n does not exist" unless $device_n ~~ [0..$number];
	#--- Check if attribute exist
	die "The provided attribute does not exist" unless defined $attributes->{$attribute};
	#---
	my $value = $attributes->{$attribute};
	return $value;
}#}}}

1;
 

