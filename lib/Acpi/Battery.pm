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

has bats_names => (
	is => 'ro',
	isa => 'ArrayRef[Str]',
	default => sub { $batts->batteries },
);

has batts_number => (
	is => 'ro',
	isa => 'Str',
	default => $nbats,
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
# - Time left

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

=head1 ATTRIBUTES

The attributes of Acpi::Battery are obtained from the values in the directory F</sys/class/power_supply/>.
Because these values may change, the attributes will also vary. The attributes of your first battery can
be obtained with the following code:

my $attributes =  Acpi::Battery::Attributes->new()->attributes;

my $bat0 = Acpi::Battery::Batteries->new()->batteries->[0];

say "-" x 50 . "\n The attributes and values of battery $bat0 are: \n" . "-" x 50;

foreach (@$attributes)

{

    my $att = $bat0 . "_" . $_;

    my $value = $battery->$att;

    say "Attribute $_ = $value";

}

say "-" x 50;

Acpi::Battery also provides these attributes for all connected batteries:

=over 

=item * energy_full:	total energy / charge

=item * energy_now:  	present energy / charge

=item * capacity		total capacity in %

=item * ac_online		if the computer is plug in

=item * batts_number	number of batteries

=item * present     	if any of the batteries is present.

=back

=head1 METHODS

Acpi::Battery only provides the object constructor method new:

my $batt = Acpi::Battery->new();

=head1 DEVELOPERS

Version 0.1 was developed by Shy <shy@cpan.org>, and has been rewritten by Mimosinnet <mimosinet@cpan.org>.

=cut

