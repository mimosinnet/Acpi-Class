#
#===============================================================================
#
#         FILE: Batteries.pm
#
#  DESCRIPTION: Get the battery names in an ArrayRef
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

use 5.010;

{
	package Acpi::Batteries;
	use Moose;

	has batteries => (
		is => 'ro',
		isa => 'ArrayRef[Str]',
		builder => '_batts',
	);

	sub _batts 
	{
		my($self) = shift;
		my($dir) = "/sys/class/power_supply";
		
		opendir(my $battery_dir, $dir) or die "Cannot open $dir : $!";
		my (@bats, $nb);
		while(readdir($battery_dir))
		{
			if ($_ =~ /BAT/)
			{
				push @bats, $_;
				$nb++;
			} 
		}
		closedir($battery_dir);
		
		die "No batteries found" unless ($nb > 0);
		
		return \@bats;
	}
}

1;
