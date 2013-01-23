#!/usr/bin/perl 

# Modules {{{
use FindBin qw($Bin);
use lib "$Bin/../lib";
use 5.010;
use strict;
use warnings;
use Acpi::Class;
# use Acpi::Battery::Values;
use Data::Dumper;
#}}}

# Variables {{{
my $class		= Acpi::Class->new;
my $first 		= $class->{devices}->[0];
my $devices 	= $class->{devices};
my $number		= $class->{number};
#my $first_battery 		= Acpi::Battery->new( battery => $name_first_battery);
# }}}

## Number of elements (ArrayRef): {{{
say "In your system there is/are $number classes";
foreach (@$devices) { print " $_";}
print "\n";
#}}}

say "-" x 60;
say "Your first class is $first";

# Elements in your class {{{
say "-" x 50 . "\n The elements in each class are:";
foreach my $dev (@$devices)
{
	my $elements = $class->devices($dev); 
	say "Class $dev has these elements: @$elements";
}
#}}}

