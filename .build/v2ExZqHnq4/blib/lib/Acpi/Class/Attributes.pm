package Acpi::Class::Attributes;
{
  $Acpi::Class::Attributes::VERSION = '0.001';
}
# ABSTRACT: Creates a HashRef with the filenames of a directory and its contents. 

# use {{{
use strict;
use warnings;
use 5.010;
use Object::Tiny::XS qw( path );
use Carp;
#}}}

sub attributes #{{{
{
	# Get the parameters from $dir 
	my $self = shift;
	my $dir  = $self->path;

	opendir (my $device, $dir)  or croak "The class/device '$dir' does not exist in your system. \n";
	my %attributes;
	while (readdir($device))
	{
		if (-f "$dir/$_")
		{
			my $content = do 
			{
				local @ARGV = "$dir/$_";
				local $/    = <ARGV>;
			};
			chomp $content if defined $content;
			$attributes{$_} = $content;
		}
	}
	return \%attributes;
}#}}}

1;

__END__

=pod

=head1 NAME

Acpi::Class::Attributes - Creates a HashRef with the filenames of a directory and its contents. 

=head1 VERSION

version 0.001

=head1 NAME

Acpi::Class::Attributes - Creates a HashRef with the filenames of a directory and its contents. 

=head1 AUTHOR

mimosinnet <mimosinet at cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Mimosinnet.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
