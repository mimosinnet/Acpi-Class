#===============================================================================
#  DESCRIPTION: Get an ArrayRef of battery names and name of adaptor
#===============================================================================

package Acpi::Battery::Batteries; 

# use modules {{{
use 5.010;
use strict;
use warnings;
use feature 'state';
use Data::Dumper;
# }}}

# Batteryh information will be the same in the same session.
# When the battery is defined, we use state to not define it again.
sub new {#{{{
	my $class = shift;
	state $instance;
	if (! defined $instance) 
	{
		my $self = {
			'dir' => "/sys/class/power_supply",
		};
		$instance = bless $self, $class;
	}
	return $instance;
}#}}}

sub batteries #{{{
{ 
	my $self = shift;
	my $dir  = $self->{dir};
	opendir(my $power_supply_dir, $dir) or die "Cannot open $dir : $!";
	my @bats;
	while(readdir($power_supply_dir))
	{
		push @bats, $_ =~ /BAT(.)/ if ($_ =~ /BAT/);
	}
	closedir($power_supply_dir);

	die "No batteries found" unless (scalar @bats > 0);
	return \@bats;
} #}}}

sub batts_number #{{{
{ 
	my $self = shift;
	my $batts_names = $self->batteries;
	my $batts_number = @$batts_names;
	chomp $batts_number;
	return $batts_number;
} #}}}

sub adaptor #{{{
{
	my $self = shift;
	my $dir = $self->{dir};
	my $adaptor;

	opendir(my $power_supply_dir, $dir) or die "Cannot open $dir : $!";
	while(readdir($power_supply_dir))
	{
		$adaptor = $_ if ($_ =~ /^A/);
	}
	closedir($power_supply_dir);
	die "

		There should be one AC adaptor. 
		Please, fill a bug with the contents of the $dir directory

	" unless defined $adaptor; 
	return $adaptor;
} #}}}

sub online  #{{{
{
	my $self = shift;
	my $adaptor = $self->adaptor;
	my $online_file = "/sys/class/power_supply/$adaptor/online";
	my $online = do
	{
		local @ARGV = $online_file;
		local $/ = <ARGV>;
	};
	chomp $online;
	return $online;
} #}}}

1;
