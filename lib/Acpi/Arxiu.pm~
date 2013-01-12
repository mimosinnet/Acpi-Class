package Acpi::Arxiu;
use Moose;

our $VERSION = '0.1';

has 'filename' => (
	is => 'rw',
	isa => 'Str',
);

has 'content' => (
	is => 'rw',
	isa => 'Str',
	lazy => 1,
	builder => '_get_file_content',
);

sub _get_file_content {
	my $self = shift;
	my $file = $self->filename;
	
    open my $fh, "<", $file or die "Unable to open $file : $!";
			local $/;
			my $file_content = <$fh>;
	close $fh;
	
	# print "file_content = $file_content \n";

	return $file_content;
}


1;

__END__

=head1 NAME

Acpi::Field - A class to extract informations in /proc/acpi/.

=head1 SYNOPSIS

use Acpi::Field;

$field = Acpi::Field->new;

print $field->getValueField("/proc/acpi/info","version")."\n";

=head1 DESCRIPTION

Acpi::Field is used into Acpi::* to extract informations.

=head1 METHOD DESCRIPTIONS

This sections contains only the methods in Field.pm itself.

=over

=item *

new();

Contructor for the class

=item *

getValueField();

Return the value into the field.

Take 2 arg : 

=over

=item 0

The path to the file.

=item 1

The field that used to extract the value.

=back

=over

=back

=head1 AUTHORS

=over

=item *

Developed by Shy <shy@cpan.org>.

=back

=cut
