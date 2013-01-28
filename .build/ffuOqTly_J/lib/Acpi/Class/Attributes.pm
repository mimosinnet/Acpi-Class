package Acpi::Class::Attributes;

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
	my $dir	 = $self->path;

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
