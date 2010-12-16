use inc::Module::Install;
all_from 'lib/CPAN/Any.pm';
readme_from('lib/CPAN/Any.pm');
requires 'UNIVERSAL::require';
requires 'parent';
build_requires 'Test::More', 0.88;
test_requires 'Test::Requires';
auto_set_repository();
write_config_pm();
WriteAll;

sub write_config_pm {
    my $client = get_client_type();

    $client = $client ? qq('$client') : "undef";

    open my $out, ">", "lib/CPAN/Any/Config.pm" or die $!;
    print $out <<EOF;
package CPAN::Any::Config;
\$PreferredClient = $client;
1;
__END__

=head1 NAME

CPAN::Any::Config - Your local CPAN::Any default preferernce

=head1 DESCRIPTION

Your current default preference for CPAN::Any is set to C<$client>.

=head1 SEE ALSO

L<CPAN::Any>

=cut
EOF
}

sub get_client_type {
    # NOTE: Both cpanm and CPANPLUS try to cheat Module::Install
    # etc. that they're CPAN.pm, so we should go with the reverse
    # order.

    if ($ENV{PERL5_CPANM_IS_RUNNING}) {
        return 'cpanminus';
    }

    # CPAN.pm sets CPANPLUS_IS_RUNNING too :(
    # https://rt.cpan.org/Ticket/Display.html?id=2373
    if ($ENV{PERL5_CPANPLUS_IS_EXECUTING}) {
        return 'CPANPLUS';
    }

    if ($ENV{PERL5_CPAN_IS_RUNNING}) {
        return 'CPAN';
    }

    return;
}
