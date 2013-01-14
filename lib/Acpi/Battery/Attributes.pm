#===============================================================================
#
#         FILE: Attributes.pm
#
#  DESCRIPTION: Getting Battery attributes
#
#        FILES: ---
#         BUGS: ---
#        NOTES: Derived from tobyink, http://www.perlmonks.org/?node_id=1012996 
#       AUTHOR: tobyink, mimosinnet
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 12/01/13 12:03:51
#     REVISION: ---
#===============================================================================

package Acpi::Battery::Attributes;
use 5.010;
use Acpi::Battery::Batteries;
use Moose;

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

# Battery Attributes
has attributes => (
	is  => "ro",
	isa => "ArrayRef[Str]",
	default => sub { \@attributes },
);

1;
