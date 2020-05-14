use Test2::V0 -no_srand => 1;
use NewFangle qw( newrelic_configure_log );

skip_all 'enable tests by running newrelic-daemon and setting PERL_NEWRELIC_LIVE_TESTS' unless $ENV{PERL_NEWRELIC_LIVE_TESTS};

newrelic_configure_log("./newrelic_sdk.log", "debug");

my $app = NewFangle::App->new;
isa_ok $app, 'NewFangle::App';

done_testing;
