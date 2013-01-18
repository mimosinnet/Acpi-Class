package Acpi::Battery;

# Modules {{{
use 5.010;
use Acpi::Field;
use Acpi::Battery::Values;
use Acpi::Battery::Batteries;
use Acpi::Battery::Attributes;
use Moose;
#}}}

# use namespace::autoclean;

# set version. {{{
# See: http://www.dagolden.com/index.php/369/version-numbers-should-be-boring/
our $VERSION = "0.200";
$VERSION = eval $VERSION;
#}}}

has battery => (#{{{
	is 		=> 'ro',
	isa 	=> 'Str',
	default => Acpi::Battery::Batteries->new->batteries->[0],
);#}}}

# Defines battery atrributes: {{{
my $attrs = Acpi::Battery::Attributes->new->attributes;
foreach my $attr (@$attrs)
{
	has $attr  	=> (
		is 		=> 'ro',
		isa 	=> 'Str',
		lazy 	=> 1,
		default => sub { my $self = shift; $self->_get_attribute($attr) },
	);
}

sub _get_attribute {
	my ($self, $attr) 	= @_;
	my $BAT				= $self->battery;       # The battery we get the attribute from
	my $value			= Acpi::Battery::Values->new( battery => $BAT )->$attr;
	return $value;
}#}}}

sub global_values 					# Gives a global value for all batteries {{{
{
	my ($self, $attribute) = @_;

	my $batteries		 = Acpi::Battery::Batteries->new;
	my $batteries_names	 = $batteries->batteries;
	my $number_batteries = $batteries->batts_number,

	my $total_value;
	foreach my $bat (@$batteries_names) 
	{
		my $value = Acpi::Battery::Values->new( battery => $bat )->$attribute;
		$total_value += $value;
	}

	if ($attribute =~ /^capacity$/) 
	{ 
		$total_value = $total_value / $number_batteries;
	}
	elsif ($attribute =~ /^present$/ )
	{ 
		$total_value = 1 if $total_value > 1;
	}

	return $total_value;
}#}}}

__PACKAGE__->meta->make_immutable;

# Things to do:
# - Remaining capacity
# - Time left

1;


