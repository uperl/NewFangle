use Test2::V0 -no_srand => 1;
use NewRelic;
use FFI::C::Util qw( c_to_perl );
use YAML qw( Dump );

my $version = NewRelic::newrelic_version();
ok $version, 'has a version number';

done_testing;
