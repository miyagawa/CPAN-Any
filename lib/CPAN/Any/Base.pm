package CPAN::Any::Base;
use strict;

sub new {
    my $class = shift;
    bless {}, $class;
}

sub name {
    my $self = shift;
    my $name = ref $self;
    $name =~ s/.*:://;
    $name;
}

1;

