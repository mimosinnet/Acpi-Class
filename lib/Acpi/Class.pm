package Acpi::Class;

# Modules {{{
use 5.010;
use strict;
use warnings;
use Acpi::Class::Devices;
use Acpi::Class::Attributes;
use Object::Tiny::RW qw( class device );
use Data::Dumper;
# }}}

# set version. {{{
# See: http://www.dagolden.com/index.php/369/version-numbers-should-be-boring/
our $VERSION = "0.001";
$VERSION = eval $VERSION;
#}}}

sub g_classes 						#{{{ List directories (ArrayRef)
{
	my $self 	= shift;
	my $devices = Acpi::Class::Devices->new( dir => "/sys/class", pattern => qr/\w/ )->devices;
	return $devices;
} #}}} 

sub g_devices						#{{{ List directories (ArrayRef)
{
	my $self = shift;
	my $class = $self->class;
	my $elements = Acpi::Class::Devices->new( dir => "/sys/class/$class", pattern => qr/\w/ )->devices;
	return \@$elements;
}#}}}

sub g_values						#{{{ filenames = attributes, content = values (HashRef)
{
	my $self = shift;
	my ($class, $device) = ($self->class, $self->device);
	my $values = Acpi::Class::Attributes->new( 'path' => "/sys/class/$class/$device" )->attributes;
	return $values;
}#}}}

sub p_device_values#{{{
{
	my $self = shift;
	my ($class, $device) = ($self->class, $self->device);
	my $values = $self->g_values;
	say "Device '$device': ";
	foreach my $key (keys %$values)
	{
		my $value = $values->{$key};
		say "   ...$key = $value";
	}
}#}}}

sub p_class_values#{{{
{
	my $self = shift;
	my $class = $self->class;
	say "Class '$class': ";
	my $all_devices = $self->g_devices;
	foreach my $dev (@$all_devices)
	{
		$self->device($dev);
		$self->p_device_values;
	}
}#}}}

1;
 

