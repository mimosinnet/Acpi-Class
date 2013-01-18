# Attributes that the battery recognises
package Acpi::Battery::Attributes;
use 5.010;
use Acpi::Battery::Batteries;

sub new
{
	my $class = shift;
	my $self = _attributes() ;
	bless $self, $class;

	return $self;
}

sub _attributes
{
	my $self = shift;
	# The parameters of both batteries should be the same
	my $bat = Acpi::Battery::Batteries->new()->batteries->[0];
	my $file = "/sys/class/power_supply/$bat/uevent";

	my $content = do
	{
			local @ARGV = $file;
			local $/    = <ARGV>;
	};

	my @attrs = $content =~ /^POWER_SUPPLY_(\w+)=.*/mg;
	my @attributes = map lc($_), @attrs;
	return { attributes => \@attributes };
}

1;
