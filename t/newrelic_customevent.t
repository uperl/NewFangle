use Test2::V0 -no_srand => 1;
use NewRelic qw( newrelic_configure_log );

skip_all 'enable tests by running newrelic-daemon and setting PERL_NEWRELIC_LIVE_TESTS' unless $ENV{PERL_NEWRELIC_LIVE_TESTS};

newrelic_configure_log("./newrelic_sdk.log", "debug");

my $event = NewRelic::CustomEvent->new('foo');
isa_ok $event, 'NewRelic::CustomEvent';

done_testing;
