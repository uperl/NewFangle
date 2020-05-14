use Test2::V0 -no_srand => 1;
use lib 't/lib';
use LiveTest;
use NewFangle qw( newrelic_configure_log );

my $app = NewFangle::App->new;

is(
  $app->start_web_transaction("web1"),
  object {
    call [ isa => 'NewFangle::Transaction' ] => T();
    call end => T();
  },
);

is(
  $app->start_non_web_transaction("nonweb1"),
  object {
    call [ isa => 'NewFangle::Transaction' ] => T();
  },
);

done_testing;
