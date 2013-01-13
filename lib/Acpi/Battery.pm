use 5.010;

package Acpi::Battery;
use Acpi::Field;
use Acpi::Info;
use Acpi::Info::Batteries;
use Acpi::Adaptor;
use strict;

our $VERSION = '0.1';

my ($rfield);

sub new{
	my $class = shift;
	my $self = {};

	bless $self,$class;

	$rfield = Acpi::Field->new; 
	return $self;
}

sub getBatteryInfo{
	my($self,$what) = @_;
	my(%value);
	my($i) = 0;
	my($numbatt) = $self->nbBattery;

	for($i=1;$i<=$numbatt;$i++){
		$value{"BAT".$i} = $rfield->getValueField("/proc/acpi/battery/BAT".$i."/info",$what);
	}

	return (%value);
}

sub getBatteryState{
	my($self,$what)= @_;
	my(%value);
	my($i) = 0;
	my($numbatt) = $self->nbBattery;

	for($i=1;$i<=$numbatt;$i++){
		$value{"BAT".$i} = $rfield->getValueField("/proc/acpi/battery/BAT".$i."/state",$what);
	}

	return (%value);
}

sub batteryOnLine
{
	# Battery is online if ac adaptor is offline
	my $self = shift;
	my $ac_adaptor_name = Acpi::Info::Batteries->new()->adaptor; 				
	my $file = "/sys/class/power_supply/$ac_adaptor_name/uevent";
	my $power_supply_online = Acpi::Adaptor->new( file => $file )->online; 
	return ! $power_supply_online;
}

sub nbBattery{
	my($self) = shift;
	my($dir) = "/sys/class/power_supply";
	my($nb) = 0;
	
	opendir(my $battery_dir, $dir) || die "Cannot open $dir : $!";
	while(readdir($battery_dir)){
		next unless $_ =~ /BAT/;
		$nb++;	
	}

	closedir($battery_dir);

	return $nb;
}

sub getLastFull{
	my($self) = shift;

	return $self->getBatteryInfo("last full capacity");
}

sub getCharge
{
	my($self) = shift;
	my($charge) = sprintf("%.1f",100*$self->getRemainingTotal/$self->getLastFullTotal);
	return $charge;
}

sub getLastFullTotal
{
	my $self = shift;
	my $batts = Acpi::Info::Batteries->new()->batteries;
	my $lastfulltotal = undef;

	foreach ( @$batts )
	{
		my $path = "/sys/class/power_supply/$_/uevent";
		my $object = Acpi::Info->new( file => $path);
		my $value = $object->energy_full || $object->charge_full;
		if ( $value == 0 ) # avoids division by 0 in getCharge subrutine
		{
			warn "
				WARNING: There is a wrong Battery Energy value reported by $path. 
				Please, report a bug in case you have a correct value"; 
			$value = 1;
		}
		$lastfulltotal += $value;
	}
	return $lastfulltotal;
}

sub getRemainingTotal 
{
    my $self = shift;
	my $batts = Acpi::Info::Batteries->new()->batteries;
	my $remainingtotal = undef;

	foreach ( @$batts )
	{
		my $path = "/sys/class/power_supply/$_/uevent";
		my $object = Acpi::Info->new( file => $path);
		my $value = $object->energy_now || $object->charge_now;
		warn "
			WARNING: There is a wrong Battery Energy value reported by $path. 
			Please, report a bug in case you have a correct value"
			if $value == 0; 

		$remainingtotal += $value;
	}
	
	return $remainingtotal;
}

sub getPresent{
	my($self) = shift;
	my(%value);
	my($i) = 0;
	my($numbatt) = $self->nbBattery;
	
	
	for($i=1;$i<=$numbatt;$i++){
		if($rfield->getValueField("/proc/acpi/battery/BAT".$i."/state","present") eq "yes"){
			$value{"BAT".$i} = 0;
		}
		else{
			$value{"BAT".$i} = -1;
		}
	}
	return (%value);
}

sub getDesignCapacity{
	my($self) = shift;

	return $self->getBatteryInfo("design capacity");
}

sub getBatteryTechnology{
	my($self) = shift;
	
	return $self->getBatteryInfo("battery technology");
}

sub getBatteryType{
	my($self) = shift;

	return $self->getBatteryInfo("battery type");
}

sub getOEMInfo{
	my($self) = shift;

	return $self->getBatteryInfo("OEM info");
}

sub getChargingState{
	my($self) = shift;
	my(%value);
        my($i) = 0;
	my($numbatt) = $self->nbBattery;


	for($i=1;$i<=$numbatt;$i++){
	        if($rfield->getValueField("/proc/acpi/battery/BAT".$i."/state","charging state") eq "charging"){
			$value{"BAT".$i} = 0;
		}
		else{
			$value{"BAT".$i} = -1;
		}
	}

	return (%value);
}

sub getCapacityState{
	my($self) = shift;
	my(%value);
	my($i) = 0;
	my($numbatt) = $self->nbBattery;

	for($i=1;$i<=$numbatt;$i++){
		if($rfield->getValueField("/proc/acpi/battery/BAT".$i."/state","capacity state") eq "ok"){
			$value{"BAT".$i} = 0;
		}
		else{
			$value{"BAT".$i} = -1;
		}
	}

	return (%value);
}

sub getRemaining{
	my($self) = shift;

	return $self->getBatteryState("remaining capacity");
}

sub getPresentRate{
	my($self) = shift;

	return $self->getBatteryState("present rate");
}

sub getPresentRateTotal{
        my($self) = shift;
	my($presentratetotal) = undef;
	my($i) = 0;
	my($numbatt) = $self->nbBattery;

	for($i=1;$i<=$numbatt;$i++){
		$presentratetotal += $rfield->getValueField("/proc/acpi/battery/BAT".$i."/state","present rate");
	}
	
	return $presentratetotal;					
}

sub getPresentVoltage{
	my($self) = shift;

	return $self->getBatteryState("present voltage");
}

sub getPresentVoltageTotal{
	my($self) = shift;
	my($presentvoltagetotal) = undef;
	my($i) = 0;
	my($numbatt) = $self->nbBattery;

	for($i=1;$i<=$numbatt;$i++){
		$presentvoltagetotal += $rfield->getValueField("/proc/acpi/battery/BAT".$i."/state","present voltage");
	}

	return $presentvoltagetotal;
}

sub getHoursLeft{
	my($self) = shift;
	
	my($hoursleft) = sprintf("%d",$self->getRemainingTotal/$self->getPresentRateTotal);
	
	return $hoursleft;
}

sub getMinutesLeft{
	my($self) = shift;
	my($remaining) = $self->getRemainingTotal;
	my($presentrate) = $self->getPresentRateTotal;
	my($hoursleft) = sprintf("%d",$self->getHoursLeft);

	my($minutesleft) = sprintf("%d",60 * ($remaining - $presentrate * $hoursleft)/$presentrate);

	return $minutesleft;
}
1;

__END__

=head1 NAME

Acpi::Battery - A class to get informations about your battery.

=head1 SYNOPSIS

use Acpi::Battery;

$battery = Acpi::Battery->new;

if($battery->batteryOnLine == 0){

	print "Battery online\n";
	
	print $battery->getCharge."\n"; 
	
	print "Time remaining ".$batteyr->getHoursLeft.":".$battery->getMinutesLeft."\n";

}

else{

print "Battery offline\n";

}

=head1 DESCRIPTION

Acpi::Battery is used to have information about your battery. It's specific for GNU/Linux

=head1 METHOD DESCRIPTIONS

This sections contains only the methods in Battery.pm itself.

=over

=item *

new();

Contructor for the class

=item *

getBatteryInfo();

Return a hash composed by the name of the battery and the information find in /proc/acpi/battery/BATX/info.

Takes 1 arg :

=over

=item 0

The information that you would find !!

=back

=item *

getBatteryState();

Return a hash composed by the name of the battery and the information find in /proc/acpi/battery/BATX/state.

Takes 1 arg :

=over

=item 0

The information that you would find !!

=back

=item *

batteryOnLine();

Return 0 if the battery is online else -1.

=item *

nbBattery();

Return the number of battery present.

=item *

getCharge();

Return the percentage of the battery.

=item *

getHoursLeft();

Return the hours left behind the battery will be down.

=item *

getMinutesLeft();

Return the minutes left behind the battery will be down.

=item * 

getLastFull();

Return a hash composed by the name of the battery and the last full capacity.

=item *

getLastFullTotal();

Return the last full capacity of all batteries.

=item *

getPresent();

Return a hash composed by the name of the battery and 0 or -1 if it's present or not.

=item *

getDesignCapacity();

Return a hash composed by the name of the battery and the design capacity.

=item *

getBatteryTechnology();

Return a hash composed by the name of the battery and the technology.

=item *

getBatteryType();

Return a hash composed by the name of the battery and the type.

=item *

getOEMInfo();

Return a hash composed by the name of the battery and the oem info.

=item *

getChargingState();

Return a hash composed by the name of the battery and 0 or -1 if it's charging or not.

=item *

getCapacityState();

Return a hash composed by the name of the battery and 0 or -1 if if the capacity state is ok or not.

=item *

getRemainingTotal();

Return the remaining capacity of all batteries.

=item * 

getPresentRateTotal();

Return the present rate of all batteries.

=item *

getPresentVoltageTotal();

Return the present voltage of all batteries.

=over

=back

=head1 AUTHORS

=over

=item *

Developed by Shy <shy@cpan.org>.

=back

=cut

