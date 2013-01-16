package Acpi::Battery;

# Modules {{{
use 5.010;
use Acpi::Field;
use Acpi::Battery::Values;
use Acpi::Battery::Batteries;
use Acpi::Battery::Attributes;
use Moose;
use Data::Dumper;
#}}}

# set version. {{{
# See: http://www.dagolden.com/index.php/369/version-numbers-should-be-boring/
our $VERSION = "0.200";
$VERSION = eval $VERSION;
#}}}

my $batts = Acpi::Battery::Batteries->new();
my $batteries = $batts->batteries;
my $online    = $batts->on_line;
my $attributes =  Acpi::Battery::Attributes->new()->attributes;
my $nbats = @$batteries;

has batts_number => (
	is => 'ro',
	isa => 'Str',
	default => $nbats,
);

has bats_names => (
	is => 'ro',
	isa => 'ArrayRef[Str]',
	default => sub { $batteries },
);

my ($energy_full, $energy_now, $capacity, $present);
foreach my $bat (@$batteries) 
{
	my $values =  Acpi::Battery::Values->new( file => "/sys/class/power_supply/$bat/uevent" );
	foreach my $attr (@$attributes)
	{
		my $value = $values->$attr;
		my $batt_attribute = $bat . "_" . $attr;
		has $batt_attribute  => (
			is => 'ro',
			isa => 'Str',
			default => $value,
		);
		if 	  ($attr =~ /energy_full$|charge_full$/) 	{ $energy_full += $value; }
		elsif ($attr =~ /energy_now$|charge_now$/) 		{ $energy_now += $value;  }
		elsif ($attr =~ /^capacity$/) 					{ $capacity += $value;    }
		elsif ($attr =~ /^present$/ )					{ $present += $value;     }
	}
	$capacity = $capacity / $nbats;
	$capacity = 100 * $energy_now / $energy_full unless $capacity > 0;
}

has energy_full => (
	is => "ro",
	isa => "Str",
	default => $energy_full,
);

has energy_now => (
	is => "ro",
	isa => "Str",
	default => $energy_now,
);

has capacity => (
	is => "ro",
	isa => "Str",
	default => $capacity,
);

has ac_online => (
	is => "ro",
	isa => "Str",
	default => $online,
);

has present => (
	is => "ro",
	isa => "Str",
	default => $present,
);

# Things to do:
# - Remaining capacity
# - Tiem left

1;

__END__

=head1 NAME

Acpi::Battery - A class to get informations about your battery.

=head1 SYNOPSIS

use Acpi::Battery;

my $battery = Acpi::Battery->new;

if ( $battery->ac_online == 0 and $battery->present == 1 )
{
	say "Ac on and battery in use ";
	say "Energy/power now = ". $battery->energy_now ; 
	say "Capacity " . $battery->capacity ." %";	
}
elsif ($battery->present)
{
	say "Battery in use";
	say "Energy/power now = ". $battery->energy_now ; 
	say "Capacity " . $battery->capacity ." %";	
}
	else
{
	say "Battery not present";
}

=head1 DESCRIPTION

Acpi::Battery is used to have information about your battery. It's specific for GNU/Linux. 
It uses the information in /sys/class/power_supply.

=head1 METHOD DESCRIPTIONS

This sections contains only the methods in Battery.pm itself.

=over

=item *

new();

Contructor for the class

=item *

getBatteryInfo();

Return a hash composed by the name of the battery and the information find in /proc/acpi/battery/BATX/info.

Takes 1 arg :

=over

=item 0

The information that you would find !!

=back

=item *

getBatteryState();

Return a hash composed by the name of the battery and the information find in /proc/acpi/battery/BATX/state.

Takes 1 arg :

=over

=item 0

The information that you would find !!

=back

=item *

batteryOnLine();

Return 0 if the battery is online else -1.

=item *

nbBattery();

Return the number of battery present.

=item *

getCharge();

Return the percentage of the battery.

=item *

getHoursLeft();

Return the hours left behind the battery will be down.

=item *

getMinutesLeft();

Return the minutes left behind the battery will be down.

=item * 

getLastFull();

Return a hash composed by the name of the battery and the last full capacity.

=item *

getLastFullTotal();

Return the last full capacity of all batteries.

=item *

getPresent();

Return a hash composed by the name of the battery and 0 or -1 if it's present or not.

=item *

getDesignCapacity();

Return a hash composed by the name of the battery and the design capacity.

=item *

getBatteryTechnology();

Return a hash composed by the name of the battery and the technology.

=item *

getBatteryType();

Return a hash composed by the name of the battery and the type.

=item *

getOEMInfo();

Return a hash composed by the name of the battery and the oem info.

=item *

getChargingState();

Return a hash composed by the name of the battery and 0 or -1 if it's charging or not.

=item *

getCapacityState();

Return a hash composed by the name of the battery and 0 or -1 if if the capacity state is ok or not.

=item *

getRemainingTotal();

Return the remaining capacity of all batteries.

=item * 

getPresentRateTotal();

Return the present rate of all batteries.

=item *

getPresentVoltageTotal();

Return the present voltage of all batteries.

=over

=back

=head1 AUTHORS

=over

=item *

Developed by Shy <shy@cpan.org>.

=back

=cut

