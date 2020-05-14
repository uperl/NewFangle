use Test2::V0 -no_srand => 1;
use NewRelic qw( newrelic_configure_log );

skip_all 'enable tests by running newrelic-daemon and setting PERL_NEWRELIC_LIVE_TESTS' unless $ENV{PERL_NEWRELIC_LIVE_TESTS};

newrelic_configure_log("./newrelic_sdk.log", "debug");

my $app = NewRelic::App->new;

is(
  $app->start_web_transaction("web1"),
  object {
    call [ isa => 'NewRelic::Transaction' ] => T();
    call end => T();
  },
);

is(
  $app->start_non_web_transaction("nonweb1"),
  object {
    call [ isa => 'NewRelic::Transaction' ] => T();
  },
);

done_testing;
