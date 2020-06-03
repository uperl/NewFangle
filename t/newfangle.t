use Test2::V0 -no_srand => 1;
use NewFangle qw( newrelic_version newrelic_set_host_display_name );
use FFI::C::Util qw( c_to_perl );

my $version = newrelic_version();
ok $version, 'has a newrelic_version number';
note "that version is $version";

newrelic_set_host_display_name('roger-rabbit');
pass 'set host display name without crash';

done_testing;
