#
#===============================================================================
#
#         FILE: Fan.pm
#
#  DESCRIPTION: 
#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: mimosinnet (), mimosinnet@ningunlugar.org
# ORGANIZATION: Associació Cultural Ningún Lugar
#      VERSION: 1.0
#      CREATED: 20/01/13 12:23:40
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
 
package Acpi::Fan;
use Acpi::Field;
use strict;
 
our $VERSION = '0.1';
 
my($rfield);
 
sub new{
    my($class) = shift;
    my($self) = {};
 
    bless($self,$class);
     
    $rfield = Acpi::Field->new;
    return $self;
}
 
sub getStatus{
    my($self) = shift;
     
    if($rfield->getValueField("/proc/acpi/fan/FAN/state","status") eq "on"){
        return 0;
    }
    else{
        return -1;
    }
}
1;
 
__END__
 
=head1 NAME
 
Acpi::Fan - A class to get informations about your fan.
 
=head1 SYNOPSIS
 
use Acpi::Fan;
 
$fan = Acpi::Fan->new;
 
print $fan->getStatus."\n";
 
=head1 DESCRIPTION
 
Acpi::Fan is used to have information about your fan.It's specific for GNU/Linux.
 
=head1 METHOD DESCRIPTIONS
 
This sections contains only the methods in Fan.pm itself.
 
=over
 
=item *
 
new();
 
Contructor for the class
 
=item *
 
getStatus();
 
Return 0 if it's active or -1.
 
=over
 
=back
 
=head1 AUTHORS
 
=over
 
=item *
 
Developed by Shy <shy@cpan.org>.
 
=back
 
=cut
