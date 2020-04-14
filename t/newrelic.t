use Test2::V0 -no_srand => 1;
use NewRelic;

my $config = NewRelic::newrelic_create_app_config("YOUR_APP_NAME", "a" x 40 );
ok $config;
note "config = $config";
ok NewRelic::newrelic_destroy_app_config(\$config);

done_testing;
