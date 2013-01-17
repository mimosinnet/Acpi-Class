# Values of the attributes for a particlar battery
package Acpi::Battery::Values;
use 5.010;
use Acpi::Battery::Attributes;
use Moose;

use namespace::autoclean;


# The values are obtained from /sys/class/power_supply/$BAT/uevent 
has file => (
	is  => "ro",
	isa => "Str",
);

# Information we get from the file transformed in attributes
my $attrs = Acpi::Battery::Attributes->new()->attributes;
my @attrs = @$attrs;
for my $attr (@attrs)
{
	has $attr => (
		is      => "ro",
		lazy    => 1,
		default => sub { my $self = shift; $self->_build($attr) }
	);
}

sub _build
{
	my ($self, $key) = @_;
	my $data = $self->_data;
	$key = "POWER_SUPPLY_" . uc($key);
	$data =~ /^$key=(.+?)$/m and $1;
}

has _data => (
	is       => "ro",
	isa      => "Str",
	lazy     => 1,
	builder  => '_build_data',
);

sub _build_data {
	my $self    = shift;
	local @ARGV = $self->file;
	local $/    = <ARGV>;
}

__PACKAGE__->meta->make_immutable;

1;
