package Acpi::Class::Devices;
{
  $Acpi::Class::Devices::VERSION = '0.001';
} 
#ABSTRACT: Gives an ArrayRef with the directores in a folder.

# use modules {{{
use 5.010;
use strict;
use warnings;
use Object::Tiny::XS qw{ dir pattern };
use Data::Dumper;
# }}}

sub devices #{{{
{ 
	my $self = shift;
	my $dir     = $self->dir;
	my $pattern = $self->pattern;
	opendir(my $device_dir, $dir) or croak "Cannot open $dir : $!";
	my @devices;
	while(readdir($device_dir))
	{
		push @devices, $_ if ($_ =~ /$pattern/x);
	}
	closedir($device_dir);

	# die "No elements found in $dir" unless (scalar @devices > 0);
	return \@devices;
} #}}}

1;

__END__

=pod

=head1 NAME

Acpi::Class::Devices - Gives an ArrayRef with the directores in a folder.

=head1 VERSION

version 0.001

=head1 NAME

Acpi::Class::Devices - Gives an ArrayRef with the directores in a folder.

=head1 AUTHOR

mimosinnet <mimosinet at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Mimosinnet.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
