package NewFangle::Transaction {

  use strict;
  use warnings;
  use 5.020;
  use NewFangle::FFI;
  use NewFangle::Segment;
  use JSON::MaybeXS ();
  use Carp ();

# ABSTRACT: NewRelic application class

=head1 SYNOPSIS

 use NewFangle;
 my $app = NewFangle::App->new;
 $app->start_web_transaction("txn_name");

=head1 DESCRIPTION

NewRelic transaction class

=head1 METHODS

=head2 start_segment

 my $seg = $txn->start_segment($name, $category);

Start a new segment.  Returns L<NewFangle::Segment> instance.

(csdk: newrelic_start_segment)

=head2 start_datastore_segment

 my $seg = $txn->start_datastore_segment([$product, $collection, $operation, $host, $port_path_or_id, $database_name, $query]);

Start a new datastore segment.  Returns L<NewFangle::Segment> instance.

(csdk: newrelic_start_datastore_segment)

=head2 start_external_segment

 my $seg = $txn->start_external_segment([$uri,$method,$library]);

Start a new external segment.  Returns L<NewFangle::Segment> instance.

(csdk: newrelic_start_external_segment)

=cut

  sub _segment
  {
    my $xsub = shift;
    my $txn = shift;
    my $seg = $xsub->($txn, @_);
    $seg->{txn} = $txn;
    $seg;
  }

  $ffi->attach( start_segment           => ['newrelic_txn_t','string','string'] => 'newrelic_segment_t' => \&_segment );
  $ffi->attach( start_datastore_segment => ['newrelic_txn_t','string[7]']       => 'newrelic_segment_t' => \&_segment );
  $ffi->attach( start_external_segment  => ['newrelic_txn_t','string[3]']       => 'newrelic_segment_t' => \&_segment );

=head2 add_attribute_int

 my $bool = $txn->add_attribute_int($key, $value);

(csdk: newrelic_add_attribute_int)

=head2 add_attribute_long

 my $bool = $txn->add_attribute_long($key, $value);

(csdk: newrelic_add_attribute_long)

=head2 add_attribute_double

 my $bool = $txn->add_attribute_double($key, $value);

(csdk: newrelic_add_attribute_double)

=head2 add_attribute_string

 my $bool = $txn->add_attribute_string($key, $value);

(csdk: newrelic_add_attribute_string)

=cut

  $ffi->attach( "add_attribute_$_" => ['newrelic_txn_t','string',$_] => 'bool' )
    for qw( int long double string );

=head2 notice_error

 $txn->notice_error($priority, $errmsg, $errclass);

For Perl you probably want to use C<notice_error_with_stacktrace>, see below.

(csdk: newrelic_notice_error)

=cut

  $ffi->attach( notice_error => [ 'newrelic_txn_t', 'int', 'string', 'string' ] );

=head2 notice_error_with_stacktrace

 $txn->notice_error_with_stacktrace($priority, $errmsg, $errorclass, $errstacktrace);

This works like notice_error above, except it lets you specify the stack trace instead
of using the C stack trace, which is likely not helpful for a Perl application.

This method requires a patch that hasn't currently been applied to the official NewRelic
C-SDK.  L<Alien::libnewrelic> should apply this fro you, but if you are building the
C-SDK yourself and need this method then you will need to apply this patch.

(csdk: notice_error_with_stacktrace)

=cut

  if($ffi->find_symbol('notice_error_with_stacktrace'))
  {
    $ffi->attach( notice_error_with_stacktrace => [ 'newrelic_txn_t', 'int', 'string', 'string', 'string' ] => sub {
      my($xsub, $self, $priority, $errmsg, $errorclass, $errstacktrace) = @_;
      $errstacktrace = [split /\n/, $errstacktrace] unless ref $errstacktrace eq 'ARRAY';
      $errstacktrace = JSON::MaybeXS::encode_json($errstacktrace);
      $xsub->($self, $priority, $errmsg, $errorclass, $errstacktrace);
    });
  }
  else
  {
    *notice_error_with_stacktrace = \&notice_error;
  }

=head2 ignore

 my $bool = $txn->ignore;

csdk: newrelic_ignore_transaction)

=cut

  $ffi->attach( [ 'ignore_transaction' => 'ignore' ] => ['newrelic_txn_t'] => 'bool' );

=head2 end

 my $bool = $txn->end;

Ends the transaction.

(csdk: newrelic_end_transaction)

=cut

  $ffi->attach( [ end_transaction => 'end' ] => ['opaque*'] => 'bool' );

=head2 record_custom_event

 $txn->record_custom_event;

(csdk: newrelic_record_custom_event)

=cut

 $ffi->attach( record_custom_event => [ 'newrelic_txn_t', 'opaque*' ] => sub {
   my($xsub, $self, $event) = @_;
   Carp::croak("event must be a NewFangle::CustomEvent")
     unless ref $event eq 'NewFangle::CustomEvent';
   $xsub->($self, $event);
   1;
 });

=head2 record_custom_metric

 $txn->record_custom_metric($name, $milliseconds);

(csdk: newrelic_record_custom_metric)

=cut

  $ffi->attach( record_custom_metric => [ 'newrelic_txn_t', 'string', 'double' ] => 'bool' );

=head2 set_name

 my $bool = $txn->set_name($name);

(csdk: newrelic_set_transaction_name)

=cut

  $ffi->attach( [ set_transaction_name => 'set_name' ] => [ 'newrelic_txn_t', 'string' ] => 'bool' );

# TODO: newrelic_create_distributed_trace_payload
# TODO: newrelic_accept_distributed_trace_payload
# TODO: newrelic_create_distributed_trace_payload_httpsafe
# TODO: newrelic_accept_distributed_trace_payload_httpsafe

  sub DESTROY
  {
    my($self) = @_;
    $self->end if defined $$self;
  }

};

1;

=head1 SEE ALSO

=over 4

=item L<NewFangle>

=back

=cut
