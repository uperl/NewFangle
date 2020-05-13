use Test2::V0 -no_srand => 1;
use NewRelic qw( newrelic_configure_log );
use YAML qw( Dump );

skip_all 'enable tests by running newrelic-daemon and setting PERL_NEWRELIC_LIVE_TESTS' unless $ENV{PERL_NEWRELIC_LIVE_TESTS};

newrelic_configure_log("./newrelic_sdk.log", "debug");

my $config = NewRelic::App->new;
isa_ok $config, 'NewRelic::App';

done_testing;
