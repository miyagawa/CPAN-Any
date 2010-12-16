package CPAN::Any::cpanminus;
use strict;
use parent qw(CPAN::Any::Base);

sub install_module {
    my($self, @modules) = @_;
    !system("cpanm", @modules);
}

1;
