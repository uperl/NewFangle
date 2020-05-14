use Test2::V0 -no_srand => 1;
use NewFangle qw( newrelic_configure_log );

skip_all 'enable tests by running newrelic-daemon and setting PERL_NEWRELIC_LIVE_TESTS' unless $ENV{PERL_NEWRELIC_LIVE_TESTS};

newrelic_configure_log("./newrelic_sdk.log", "debug");

my $app = NewFangle::App->new;

my $txn = $app->start_web_transaction("web3");

is(
  $txn->start_segment("foo",undef),
  object {
    call [ isa => 'NewFangle::Segment' ] => T();
    call end => T();
  },
);


is(
  $txn->start_datastore_segment(["MySQL",undef,undef,undef,undef,undef,"SELECT * FROM foo"]),
  object {
    call [ isa => 'NewFangle::Segment' ] => T();
  },
);

is(
  $txn->start_external_segment(["http://foo.com", "GET", undef]),
  object {
    call [ isa => 'NewFangle::Segment' ] => T();
  },
);

done_testing;
