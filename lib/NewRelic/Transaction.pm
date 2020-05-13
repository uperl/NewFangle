package NewRelic::Transaction {

  use strict;
  use warnings;
  use 5.020;
  use NewRelic::FFI;
  use NewRelic::Segment;
  use Carp ();

# ABSTRACT: NewRelic application class

=head1 SYNOPSIS

 use NewRelic;
 my $app = NewRelic::App->new;
 $app->start_web_transaction("txn_name");

=head1 DESCRIPTION

NewRelic transaction class

=head1 METHODS

=head2 start_segment

 my $seg = $txn->start_segment($name, $category);

Start a new segment.  Returns L<NewRelic::Segment> instance.

(csdk: newrelic_start_segment)

=head2 start_datastore_segment

 my $seg = $txn->start_datastore_segment([$product, $collection, $operation, $host, $port_path_or_id, $database_name, $query]);

Start a new datastore segment.  Returns L<NewRelic::Segment> instance.

(csdk: newrelic_start_datastore_segment)

=head2 start_external_segment

 my $seg = $txn->start_external_segment([$uri,$method,$library]);

Start a new external segment.  Returns L<NewRelic::Segment> instance.

(csdk: newrelic_start_external_segment)

=cut

  sub _segment
  {
    my $xsub = shift;
    my $txn = shift;
    my $seg = $xsub->($txn, @_);
    $seg->{txn} = $txn if $seg;
    $seg;
  }

  $ffi->attach( start_segment           => ['newrelic_txn_t','string','string'] => 'newrelic_segment_t' => \&_segment);
  $ffi->attach( start_datastore_segment => ['newrelic_txn_t','string[7]']       => 'newrelic_segment_t' => \&_segment);
  $ffi->attach( start_external_segment  => ['newrelic_txn_t','string[3]']       => 'newrelic_segment_t' => \&_segment);

=head2 end

 my $bool = $txn->end;

Ends the transaction.

(csdk: newrelic_end_transaction)

=cut

  $ffi->attach( [ end_transaction => 'end' ] => ['opaque*'] => 'bool');

  sub DESTROY
  {
    my($self) = @_;
    $self->end if defined $$self;
  }

};

1;

=head1 SEE ALSO

=over 4

=item L<NewRelic>

=back

=cut
