package NewRelic::CustomEvent {

  use strict;
  use warnings;
  use 5.020;
  use NewRelic::FFI;
  use Carp ();

# ABSTRACT: NewRelic custom event class

=head1 SYNOPSIS

 use NewRelic;
 my $event = NewRelic::CustomEvent->new("my event");

=head1 DESCRIPTION

NewRelic custom event class.

=head1 CONSTRUCTOR

=head2 new

 my $event = NewRelic::CustomEvent->new($event_type();

Creates a NewRelic application custom event.

(csdk: newrelic_create_custom_event)

=cut

  $ffi->attach( [ create_custom_event => 'new' ] => ['string'] => 'newrelic_custom_event_t' => sub {
    my($xsub, undef, $event_type) = @_;
    my $self = $xsub->($event_type);
    Carp::croak("unable to create NewRelic::CustomEvent instance, see log for details") unless defined $self;
    $self;
  });

  $ffi->attach( [ discard_custom_event => 'DESTROY' ] => ['opaque*'] => 'bool' => sub {
    my($xsub, $self) = @_;
    my $ptr = $$self;
    $xsub->(\$ptr) if $ptr;
  });

};

1;

=head1 SEE ALSO

=over 4

=item L<NewRelic>

=back

=cut
