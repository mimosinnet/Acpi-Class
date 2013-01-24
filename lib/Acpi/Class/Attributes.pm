package Acpi::Class::Attributes;
use strict;
use warnings;
use 5.010;
use Object::Tiny::XS qw( path );

sub attributes
{
	# Get the parameters from $dir 
	my $self = shift;
	my $dir	 = $self->path;

	opendir (my $device, $dir)  or die "Cannot open $dir : $!";
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
			chomp $content;
			$attributes{$_} = $content;
		}
	}
	return \%attributes;
}

1;
