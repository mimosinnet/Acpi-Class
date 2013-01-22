package Acpi::Battery;

# Modules {{{
use 5.010;
use strict;
use warnings;
use Acpi::Battery::Batteries;
use Acpi::Battery::Attributes;
use Acpi::Battery::Values;
use Acpi::Utils::Devices;
#}}}

# set version. {{{
# See: http://www.dagolden.com/index.php/369/version-numbers-should-be-boring/
our $VERSION = "0.200";
$VERSION = eval $VERSION;
#}}}

sub new {#{{{   
	my ($class, $device_n) = @_;
    $device_n = 0 unless defined $device_n;
	my $batteries = Acpi::Battery::Batteries->new;
	my $self = {
		'number'   			=>  Acpi::Utils::Devices->new
			(
				dir => "/sys/class/power_supply", 
				pattern => "BAT" 
			)->number,
		'device_n' 			=> $device_n,
		'batteries'			=> $batteries->batteries,
		'adpator'			=> $batteries->adaptor,
		'online'			=> $batteries->online,
		'default_battery' 	=> $batteries->batteries->[0],
		'attributes'	  	=> Acpi::Battery::Attributes::attributes(),
	};
	bless $self, $class;
	return $self;
}#}}}

sub value 							# get value of a battery attribute {{{
{
	my ($self, $attribute) = @_;
	my $number = $self->{number};
	my $device_n = $self->{device_n};
	$device_n = 0 unless defined $device_n;
	die "Battery device $device_n does not exist" unless $device_n ~~ [0..$number];
	#--- Check if attribute exist
	my $attributes = Acpi::Battery::Attributes::attributes( $device_n );
	my %param = map { $_ => 1 } @$attributes;
	die "The provided attribute does not exist" unless exists  $param{$attribute};
	#---
	my $battery = Acpi::Battery::Values->new( battery => $device_n);
	my $value 	= $battery->values->{$attribute};
	return $value;
}#}}}

sub global_values 					# Gives a global value for all batteries {{{
{
	my ($self, $attribute) = @_;

	my $batteries_names	 = $self->{batteries};
	my $number_batteries = $self->{number},

	my $total_value;
	foreach my $bat (@$batteries_names) 
	{
		my $value = Acpi::Battery::Values->new( battery => $bat )->values->{$attribute};
		$total_value += $value if defined $value;
	}

	if ($attribute =~ /^capacity$/) 
	{ 
		$total_value = $total_value / $number_batteries;
	}
	elsif ($attribute =~ /^present$/ )
	{ 
		$total_value = 1 if $total_value > 1;
	}

	$total_value = "The battery does no provide attribute: $attribute" unless defined $total_value;

	return $total_value;
}#}}}

# Things to do:
# - Remaining capacity
# - Time left

1;


