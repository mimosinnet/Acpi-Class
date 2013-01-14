#
#===============================================================================
#
#         FILE: Values.pm
#
#  DESCRIPTION: Getting Battery Values
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

use 5.010;

{
    package Acpi::Battery::Values;
    use Moose;

	# File from which we get the information
	has file => (
        is  => "ro",
        isa => "Str",
    );

	# Information we get from the file transformed in attributes
	# Some kernel versions use "energy" and others use "charge"
	
    my @attrs = qw<
		capacity
		charge_full
		charge_full_design
		charge_now
		cycle_count
		current_now
		power_now
        energy_full
        energy_full_design
        energy_now
        manufacturer
        model_name
        name
        present
        serial_number
        status
        technology
        voltage_min_design
        voltage_now
    >;

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
}

1;
