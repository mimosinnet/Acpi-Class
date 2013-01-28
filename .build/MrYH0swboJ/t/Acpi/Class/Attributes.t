#!/usr/bin/env perl 

# Modules {{{
use FindBin qw($Bin);
use lib "$Bin/../../../lib";
use strict;
use warnings;
use Test::More;
use Acpi::Class::Attributes;
# }}}

# Define Variables {{{
my $value = Acpi::Class::Attributes->new( path => "$Bin/test/dir3" )->attributes->{'attribute'};
my $content = "yes";
#}}}

ok( $value = $content, "Acpi::Class::Attributes reads file");

done_testing();
