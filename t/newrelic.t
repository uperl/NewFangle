use Test2::V0 -no_srand => 1;
use NewRelic;
use FFI::C::Util qw( c_to_perl );
use YAML qw( Dump );

my $config = NewRelic::newrelic_create_app_config("YOUR_APP_NAME", "a" x 40 );
isa_ok $config, 'NewRelic::NewrelicAppConfig';
note Dump(c_to_perl $config);
ok NewRelic::newrelic_destroy_app_config($config);

done_testing;
