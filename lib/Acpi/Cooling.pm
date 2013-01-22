package Acpi::Cooling;

# Modules {{{
use 5.010;
use strict;
use warnings;
use Acpi::Cooling::CoolingDevices;
use Data::Dumper;

# set version. {{{
# See: http://www.dagolden.com/index.php/369/version-numbers-should-be-boring/
our $VERSION = "0.200";
$VERSION = eval $VERSION;
#}}}


sub new {
    my ($class, $cooling_device_n) = @_;
	$cooling_device_n = 0 unless defined $cooling_device_n;
    my($self) = {
		'cooling_number'   =>  Acpi::Cooling::CoolingDevices->new()->cooling_number,
		'cooling_device_n' =>  $cooling_device_n,
	};
 
    bless $self, $class;
    return $self;
}


sub value 							# get value {{{
{
	my ($self, $attribute) = @_;
	my $cooling_number = $self->{cooling_number};
	my $cooling_device_n = $self->{cooling_device_n};
	$cooling_device_n = 0 unless defined $cooling_device_n;
	die "Cooling device $cooling_device_n does not exist" unless $cooling_device_n ~~ [0..$cooling_number];
	#--- Check if attribute exist
	
	my $attributes = Acpi::Cooling::Attributes::attributes( $cooling_device_n );
	die "The provided attribute does not exist" unless defined $attributes->{$attribute};
	#---
	my $value = $attributes->{$attribute};
	return $value;
}#}}}

1;
 

