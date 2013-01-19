# Values of the attributes for a particlar battery
package Acpi::Battery::Values;

# use modules {{{
use 5.010;
use strict;
use warnings;
use Acpi::Battery::Batteries;
#}}}

sub new {#{{{
	my $class = shift;
	my $self = {
		'default_battery' 	=> Acpi::Battery::Batteries->new->batteries->[0],
	};
	bless $self, $class;
	return $self;
}#}}}

sub values #{{{
{
	my $self = shift;
	my $battery = $self->{battery};
	$battery ||= $self->{default_battery};
	my $uevent = "/sys/class/power_supply/$battery/uevent";
	my $content = do {
		local @ARGV = $uevent;
		local $/    = <ARGV>;
	};

	my %values = $content =~ /^POWER_SUPPLY_(\w+)=(.+)$/mg;
	foreach my $key (keys %values) 
	{
		my $newkey = lc $key;
		$values{$newkey} = delete $values{$key};
	}
	return \%values;
}#}}}

1;
