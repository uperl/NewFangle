use Test2::V0 -no_srand => 1;
use NewRelic;
use FFI::C::Util qw( c_to_perl );
use YAML qw( Dump );

my $version = NewRelic::newrelic_version();
diag '';
diag '';
diag '';

diag "newrelic_version = $version";

diag '';
diag '';

my $config = NewRelic::newrelic_create_app_config("YOUR_APP_NAME", "a" x 40 );

diag Dump(c_to_perl $config);
diag '';
diag '';

isa_ok $config, 'NewRelic::NewrelicAppConfig';
ok NewRelic::newrelic_destroy_app_config($config);

done_testing;
