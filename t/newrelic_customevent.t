use Test2::V0 -no_srand => 1;
use lib 't/lib';
use LiveTest;
use NewFangle qw( newrelic_configure_log );

my $event = NewFangle::CustomEvent->new('foo');
isa_ok $event, 'NewFangle::CustomEvent';

done_testing;
