#
#===============================================================================
#
#         FILE: Values.pm
#
#  DESCRIPTION: get battery vaules from /sys/class/power_supply/BATx/uevent
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 10/01/13 07:02:19
#     REVISION: ---
#===============================================================================

package Acpi::Battery::Values;
use Acpi::Arxiu;
use Moose;

has 'directory' => (
	is => "ro",
	isa => "Str",
);

my $dir = "/sys/class/power_supply/BAT1/uevent";
my $object = Acpi::Arxiu->new(filename => "$dir");
my $content = $object->content;
my %value = $content =~ /^POWER_SUPPLY_(\w+)=(.+)$/mg;

foreach (keys %value) {
	has lc($_) => (
		is => "ro",
		default => $value{$_},
	);
}

1;
