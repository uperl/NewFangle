use Test2::V0 -no_srand => 1;
use NewRelic;
use YAML qw( Dump );

$ENV{NEWRELIC_LICENSE_KEY} = 'a' x 40;

my $config = NewRelic::Config->new;
isa_ok $config, 'NewRelic::Config';
note Dump($config->to_perl);

done_testing;
