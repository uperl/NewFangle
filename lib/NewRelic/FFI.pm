package NewRelic::FFI {

  use strict;
  use warnings;
  use 5.020;
  use FFI::CheckLib 0.27 ();
  use FFI::Platypus 1.26;
  use base qw( Exporter );

  our @EXPORT = qw( $ffi );

# ABSTRACT: Private class for NewRelic.pm

=head1 SYNOPSIS

 % perldoc NewRelic

=head1 DESCRIPTION

This is part of the internal workings for L<NewRelic>.

=head1 SEE ALSO

=over 4

=item L<NewRelic>

=back

=cut

  our $ffi = FFI::Platypus->new(
    api => 1,
    lib => [do {
      my $lib = FFI::CheckLib::find_lib lib => 'newrelic';
      $lib
        ? $lib
        : FFI::CheckLib::find_lib lib => 'newrelic', alien => 'Alien::libnewrelic',
    }],
  );
  $ffi->mangler(sub { "newrelic_$_[0]" });
  $ffi->load_custom_type('::PtrObject', 'newrelic_segment_t', 'NewRelic::Segment');
  $ffi->type('object(NewRelic::Transaction)' => 'newrelic_txn_t');


};

1;

