package NewRelic;

use strict;
use warnings;
use 5.008001;
use Alien::libnewrelic;
use FFI::Platypus 1.00;

# ABSTRACT: Unofficial Perl NewRelic SDK
# VERSION

my $ffi = FFI::Platypus->new(
  api => 1,
  lib => [Alien::libnewrelic->dynamic_libs],
);

$ffi->attach( newrelic_create_app_config  => ['string','string'] => 'opaque' );
$ffi->attach( newrelic_destroy_app_config => ['opaque*'] => 'bool' );

1;


