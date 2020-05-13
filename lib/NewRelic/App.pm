package NewRelic::App {

  use strict;
  use warnings;
  use 5.020;
  use NewRelic::FFI;
  use Carp ();

# ABSTRACT: NewRelic application class

=head1 SYNOPSIS

 use NewRelic;
 my $app = NewRelic::App->new;

=head1 DESCRIPTION

NewRelic application class.

=head1 CONSTRUCTOR

=head2 new

 my $app = NewRelic::App->new($config, $timeout_ms);
 my $app = NewRelic::App->new(\%config, $timeout_ms);
 my $app = NewRelic::App->new;

Creates a NewRelic application instance.  The first argument may be one of:

=over 4

=item L<NewRelic::Config> instance

=item Hash reference

Containing the initialization for a config instance which will be created internally.

=back

If C<$timeout_ms> is the maximum time to wait for a connection to be established.  If not
provided then only one attempt at connecting to the daemon will be made.

(csdk: newrelic_create_app)

=cut

  $ffi->type('object(NewRelic::App)' => 'newrelic_app_t');

  $ffi->attach( [ create_app => 'new' ] => ['newrelic_app_config_t', 'unsigned short'] => 'newrelic_app_t' => sub {
    my($xsub, undef, $config, $timeout) = @_;
    $config //= {};
    $config = NewRelic::Config->new(%$config) if ref $config eq 'HASH';
    $timeout //= 0;
    my $self = $xsub->($config->{config});
    Carp::croak("unable to NewRelic::App instance, see log for details") unless defined $self;
    $self;
  });

  $ffi->attach( [ destroy_app => 'DESTROY' ] => ['opaque*'] => 'bool' => sub {
    my($xsub, $self) = @_;
    my $ptr = $$self;
    $xsub->(\$ptr);
  });

};

1;

=head1 SEE ALSO

=over 4

=item L<NewRelic>

=back

=cut
