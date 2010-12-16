package CPAN::Any;

use strict;
use 5.008_001;
our $VERSION = '0.01';

use Carp ();
use UNIVERSAL::require;

our $ClientNames = {
    cpan      => 'CPAN::Any::CPAN',
    cpanp     => 'CPAN::Any::CPANPLUS',
    cpanplus  => 'CPAN::Any::CPANPLUS',
    cpanm     => 'CPAN::Any::cpanminus',
    cpanminus => 'CPAN::Any::cpanminus',
};

sub _preference {
    my $class = shift;

    if ($ENV{PERL_PREFER_CPAN_CLIENT}) {
        return $ENV{PERL_PREFER_CPAN_CLIENT};
    }

    if (eval { require CPAN::Any::Config; 1 }) {
        return $CPAN::Any::Config::PreferredClient;
    }

    return;
}

sub auto {
    my $class = shift;

    my $type = $class->_preference || 'cpan';
    $class->new($type);
}

sub new {
    my($class, $type) = @_;

    my $backend = $ClientNames->{lc($type)}
        or Carp::croak("Couldn't find the installer type '$type'");

    $backend->require or Carp::croak("$backend: $@");
    $backend->new;
}

sub install_module { shift->auto->install_module(@_) }

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

CPAN::Any - Install Perl modules using any of CPAN clients

=head1 SYNOPSIS

  use CPAN::Any;

  # install modules using the user's favorite installer
  CPAN::Any->install_module("Plack");

  # explicitly specify which client to use
  my $cpan = CPAN::Any->new("cpanm");
  $cpan->install_module("Catalyst");

=head1 DESCRIPTION

CPAN::Any is an interface to install Perl modules using any CPAN client.

=head1 WHY

There are many tools and modules that use (one of) CPAN clients to
install modules, and most of them hardcode the author's favorite CPAN
clients, either L<CPAN>, L<CPANPLUS> or L<cpanm>. Examples are
L<Dist::Zilla>, L<App::CPAN::Fresh>, L<Acme::Everything>,
L<Module::AutoINC> and L<CPAN::AutoINC>, but could be more.

L<CPAN::Any> provides one unified interface to install modules, and
which client to use is now up to user's own configuration.

=head1 METHODS

=over 4

=item install_module

  CPAN::Any->install_module($package [, ... ]);

Install the module using its package name. Calling this method as a
class method is equivalent to:

  my $client = CPAN::Any->auto;
  $client->install_module($package);

=back

=head1 PREFERENCE

C<< CPAN::Any->install_module($module) >> and friends will
automatically detect which client to use, based on the following order.

=over 4

=item PERL_PREFER_CPAN_CLIENT

Users can set the environment variable C<PERL_PREFER_CPAN_CLIENT> to
the acceptable client name. Acceptable values are C<CPAN>, C<CPANP>,
C<CPANPLUS>, C<cpanm> and C<cpanminus>.

=item CPAN::Any::Config

When this module (L<CPAN::Any>) is installed from L<CPAN>, L<CPANPLUS>
or L<cpanm> it automatically sets up the current installer you use as
the preferred installer type in L<CPAN::Any::Config> module and
installs it in your site include path.

You can reinstall modules using one of those installers to change the
default preference.

=item fallback to CPAN

If none of the above is set, the default installer is L<CPAN>.

=back

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

=head1 COPYRIGHT

Copyright 2010- Tatsuhiko Miyagawa

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<CPAN>, L<CPANPLUS>, L<App::cpanminus>

=cut
