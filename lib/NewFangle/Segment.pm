package NewFangle::Segment {

  use strict;
  use warnings;
  use 5.020;
  use NewFangle::FFI;
  use Carp ();

# ABSTRACT: NewRelic application class

=head1 SYNOPSIS

 use NewFangle;
 my $app = NewFangle::App->new;
 my $txn = $app->start_web_transaction("txn_name");
 my $seg = $txn->start_segment("seg_name");

=head1 DESCRIPTION

NewRelic transaction class

=head1 METHODS

=head2 transaction

 my $txn = $seg->transaction

Returns the transaction for this segment.

=cut

  sub transaction { shift->{txn} }

=head2 end

 my $bool = $seg->end;

Ends the segment.

(csdk: newrelic_end_segment)

=cut

  $ffi->attach( [ end_segment => 'end' ] => ['newrelic_txn_t', 'opaque*'] => 'bool' => sub {
    my($xsub, $self) = @_;
    my $txn = $self->{txn};
    $xsub->($self->{txn}, \$self->{ptr});
  });

  sub DESTROY
  {
    my($self) = @_;
    $self->end if defined $self->{ptr};
  }

};

1;

=head1 SEE ALSO

=over 4

=item L<NewFangle>

=back

=cut
