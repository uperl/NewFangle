package NewFangle::Lib {

  use strict;
  use warnings;
  use 5.014;
  use FFI::CheckLib 0.28 qw( find_lib );

# ABSTRACT: Private class for NewFangle.pm

=head1 SYNOPSIS

 % perldoc NewFangle

=head1 DESCRIPTION

This is part of the internal workings for L<NewFangle>.

=head1 SEE ALSO

=over 4

=item L<NewFangle>

=back

=cut

  sub lib {
    find_lib lib => 'newrelic', alien => 'Alien::libnewrelic';
  }

}

1;
