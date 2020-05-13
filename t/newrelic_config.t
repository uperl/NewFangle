use Test2::V0 -no_srand => 1;
use NewRelic;
use YAML qw( Dump );

my $config = NewRelic::Config->new;
isa_ok $config, 'NewRelic::Config';
note Dump($config->to_perl);

done_testing;
