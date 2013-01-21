package Acpi::ThermalZone;
use Acpi::Field;
use strict;
use warnings;
use 5.010;
use Data::Dumper;

# set version. {{{
# See: http://www.dagolden.com/index.php/369/version-numbers-should-be-boring/
our $VERSION = "0.200";
$VERSION = eval $VERSION;
#}}}

sub new{
    my($class) = shift;
    my($self) = {};
 
    bless($self,$class);
    return $self;
}


sub value 							# get value of a battery attribute {{{
{
	my ($self, $attribute) = @_;
	#--- Check if attribute exist
	my $attributes = Acpi::ThermalZone::Attributes::attributes();
	die "The provided attribute does not exist" unless defined $attributes->{$attribute};
	#---
	my $value = $attributes->{$attribute};
	return $value;
}#}}}

1;
 

