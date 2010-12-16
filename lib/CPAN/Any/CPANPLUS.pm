package CPAN::Any::CPANPLUS;
use strict;
use parent qw(CPAN::Any::Base);

use CPANPLUS ();

my $backend;

sub install_module {
    my($self, @modules) = @_;

    $backend ||= CPANPLUS::Backend->new;
    $backend->install(modules => \@modules);
}

1;
