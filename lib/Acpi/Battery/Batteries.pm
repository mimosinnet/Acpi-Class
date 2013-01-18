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

package Acpi::Battery::Batteries;#{{{
use 5.010;
use Moose;
use namespace::autoclean;#}}}

has dir => (#{{{
	is => 'ro',
	isa => 'Str',
	default => '/sys/class/power_supply',
);#}}}

has batteries => (#{{{
	is => 'ro',
	isa => 'ArrayRef[Str]',
	lazy => 1,
	builder => '_batteries',
);#}}}

has batts_number => (	#{{{
	is => 'ro',
	isa => 'Str',
	lazy => 1,
	default => sub { my $self = shift; $self->_batts_number },
);#}}}

has adaptor => (#{{{
	is => 'ro',
	isa => 'Str',
	lazy => 1,
	builder => '_adaptor',
);

sub _adaptor 
{
	my $self = shift;
	my $dir = $self->dir;
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
}

#}}}

has on_line => (#{{{
	is => 'ro',
	isa => 'Bool',
	lazy => 1,
	builder => '_online',
);

sub _online
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
}

#}}}

sub _batteries #{{{
{
	my $self = shift;
	my $dir = $self->dir;

	opendir(my $power_supply_dir, $dir) or die "Cannot open $dir : $!";
	my @bats;
	while(readdir($power_supply_dir))
	{
		push @bats, $_ if ($_ =~ /BAT/);
	}
	closedir($power_supply_dir);

	die "No batteries found" unless (scalar @bats > 0);
	return \@bats;
}#}}}

sub _batts_number		#{{{
{
	my $self = shift;
	my $batts_names = $self->batteries;
	my $batts_number = @$batts_names;
	chomp $batts_number;
	return $batts_number;
}#}}}



__PACKAGE__->meta->make_immutable;

1;
