#
#===============================================================================
#
#         FILE: Batteries.pm
#
#  DESCRIPTION: Get an ArrayRef of battery names and name of adaptor
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), 
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 12/01/13 13:23:14
#     REVISION: ---
#===============================================================================

use 5.010;
use Data::Dumper;

# Get the variables that will be used by the builder subrutines.
# No sure if this is the right approach

my $dir = "/sys/class/power_supply";
opendir(my $battery_dir, $dir) or die "Cannot open $dir : $!";
my (@bats, $adaptor, $nb, $na);
while(readdir($battery_dir))
{
	if ($_ =~ /BAT/)
	{
		push @bats, $_;
		$nb++;
	} 
	elsif ($_ =~ /A.*/)
	{
		$adaptor = $_;
		$na++;
	}
	
}
closedir($battery_dir);

die "No batteries found" unless ($nb > 0);
die "
		The number of AC adaptors should be one, and more or none have been found. 
		Please, fill a bug with the contents of the $dir directory
	"
	unless $na == 1; 

my $online_file = "/sys/class/power_supply/$adaptor/online";
my $online = do
{
	local @ARGV = $online_file;
	local $/ = <ARGV>;
};
chomp $online;


{
	package Acpi::Battery::Batteries;
	use Moose;

	has batteries => (
		is => 'ro',
		isa => 'ArrayRef[Str]',
		default => sub { \@bats },
	);

	has adaptor => (
		is => 'ro',
		isa => 'Str',
		default => $adaptor,
	);

	has on_line => (
		is => 'ro',
		isa => 'Bool',
		default => $online,
	);


	sub _online 
	{
		my $self = shift;
		return 1;
	}
}

1;
