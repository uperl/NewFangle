package NewFangle::App {

  use strict;
  use warnings;
  use 5.020;
  use NewFangle::FFI;
  use NewFangle::Transaction;
  use Carp ();

# ABSTRACT: NewRelic application class

=head1 SYNOPSIS

 use NewFangle;
 my $app = NewFangle::App->new;

=head1 DESCRIPTION

NewRelic application class.

=head1 CONSTRUCTOR

=head2 new

 my $app = NewFangle::App->new($config, $timeout_ms);
 my $app = NewFangle::App->new(\%config, $timeout_ms);
 my $app = NewFangle::App->new;

Creates a NewFangle application instance.  The first argument may be one of:

=over 4

=item L<NewFangle::Config> instance

=item Hash reference

Containing the initialization for a config instance which will be created internally.

=back

If C<$timeout_ms> is the maximum time to wait for a connection to be established.  If not
provided then only one attempt at connecting to the daemon will be made.

(csdk: newrelic_create_app)

=cut

  $ffi->attach( [ create_app => 'new' ] => ['newrelic_app_config_t', 'unsigned short'] => 'newrelic_app_t' => sub {
    my($xsub, undef, $config, $timeout) = @_;
    $config //= {};
    $config = NewFangle::Config->new(%$config) if ref $config eq 'HASH';
    $timeout //= 0;
    my $self = $xsub->($config->{config});
    unless(defined $self)
    {
      my $ptr = undef;
      $self = bless \$ptr, __PACKAGE__;
    }
    $self;
  });

=head2 start_web_transaction

 my $txn = $app->start_web_transaction($name);

Starts a web based transaction.  Returns the L<NewFangle::Transaction> instance.

(csdk: newrelic_start_web_transaction)

=head2 start_non_web_transaction

 my $txn = $app->start_non_web_transaction($name);

Starts a non-web based transaction.  Returns the L<NewFangle::Transaction> instance.

(csdk: newrelic_start_web_transaction)

=cut

  sub _txn_wrapper {
    my $xsub = shift;
    my $txn = $xsub->(@_);
    $txn //= do {
      my $ptr = undef;
      $txn = bless \$ptr, 'NewFangle::Transaction';
    };
    $txn;
  }

  $ffi->attach( start_non_web_transaction => ['newrelic_app_t','string'] => 'newrelic_txn_t', \&_txn_wrapper );
  $ffi->attach( start_web_transaction     => ['newrelic_app_t','string'] => 'newrelic_txn_t', \&_txn_wrapper );

  $ffi->attach( [ destroy_app => 'DESTROY' ] => ['opaque*'] => 'bool' => sub {
    my($xsub, $self) = @_;
    my $ptr = $$self;
    $xsub->(\$ptr);
  });

};

1;

=head1 SEE ALSO

=over 4

=item L<NewFangle>

=back

=cut
