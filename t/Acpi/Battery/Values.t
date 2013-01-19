#!/usr/bin/env perl 
#===============================================================================
#  DESCRIPTION: Test if the values of /sys/class/power_supply/BATx/uevent are
#  				attributes of Acpi::Battery::Values
#===============================================================================

# Modules {{{
use FindBin qw($Bin);
use lib "$Bin/../../../lib";
use strict;
use warnings;
use Test::More;
use utf8;
use 5.010;
use Acpi::Battery::Values;
use Acpi::Battery::Batteries;
# }}}

# Define Variables {{{
my $bat = Acpi::Battery::Batteries->new->batteries->[0];		# Name of first Battery 
my $acpi_values = Acpi::Battery::Values->new( battery => $bat );
#}}}

# Get the parameters of the first battery from uevent_file {{{
my $values = do                              	# Read the file 
{
    local @ARGV = "/sys/class/power_supply/$bat/uevent";
    local $/    = <ARGV>;
};

my @file_parameters;                            # Read the parameters
foreach ( split /\n/, $values )
{
	my ($a) = ($_ =~ /^POWER_SUPPLY_(.+?)=.*$/); 
	push @file_parameters, lc $a;
}
# }}}

# Test 1: see if we can get the battery name {{{
my $b = $acpi_values->values->{'model_name'};

ok ( $b =~ /\w/, "Battery name: $b");
# }}}

# Tests: see if the parameters of battery are attributes of object Acpi::Battery::Values {{{
foreach ( @file_parameters )
{
	eval { my $parameter = $acpi_values->values->{$_}; };
	ok ( $@ eq "", "The attribute '$_' does not give an error in the method: Acpi::Battery::Values::values" );
}
# }}}

done_testing();
