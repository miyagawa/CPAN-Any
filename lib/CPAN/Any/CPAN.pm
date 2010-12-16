package CPAN::Any::CPAN;
use strict;
use parent qw(CPAN::Any::Base);

use CPAN ();

sub install_module {
    my($self, @modules) = @_;

    my @r;
    for my $module (@modules) {
        my $mod = CPAN::Shell->expand("Module", $module);
        push @r, CPAN::Shell->install($mod); # Seems CPAN.pm passes 1 even if it fails
    }

    return @r == @modules;
}

1;
