package Acpi::Cooling;

# Modules {{{
use 5.010;
use strict;
use warnings;
use Acpi::Cooling::CoolingDevices;
use Acpi::Utils::Devices;
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
    my($self) = {
		'number'   =>  Acpi::Utils::Devices->new
			(
				dir => "/sys/class/thermal", 
				pattern => "cooling" 
			)->number,
		'device_n' =>  $device_n,
	};
 
    bless $self, $class;
    return $self;
}

sub value 							# get value {{{
{
	my ($self, $attribute) = @_;
	my $number = $self->{number};
	my $device_n = $self->{device_n};
	$device_n = 0 unless defined $device_n;
	die "Cooling device $device_n does not exist" unless $device_n ~~ [0..$number];
	#--- Check if attribute exist
	my $attributes = Acpi::Cooling::Attributes::attributes( $device_n );
	die "The provided attribute does not exist" unless defined $attributes->{$attribute};
	#---
	my $value = $attributes->{$attribute};
	return $value;
}#}}}

1;
 

