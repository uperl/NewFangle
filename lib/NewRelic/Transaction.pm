package NewRelic::Transaction {

  use strict;
  use warnings;
  use 5.020;
  use NewRelic::FFI;
  use Carp ();

# ABSTRACT: NewRelic application class

  $ffi->type('object(NewRelic::Transaction)' => 'newrelic_txn_t');

=head1 SYNOPSIS

 use NewRelic;
 my $app = NewRelic::App->new;
 $app->start_web_transaction("txn_name");

=head1 DESCRIPTION

NewRelic transaction class

=head1 METHODS

=head1 end

 my $bool = $txn->end;

Ends the transaction.

=cut

  $ffi->attach( [ end_transaction => 'end' ] => ['opaque*'] => 'bool' => sub {
    my($xsub, $self) = @_;
    my $ret = $xsub->($self);
    $ret;
  });

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
