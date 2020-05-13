package NewRelic {

  use strict;
  use warnings;
  use 5.020;
  use FFI::CheckLib 0.27 ();
  use FFI::Platypus 1.26;
  use FFI::C 0.08;
  use Ref::Util qw( is_blessed_ref );
  use FFI::C::Util qw( take );
  use Carp qw( croak );

# ABSTRACT: Unofficial Perl NewRelic SDK

  my $ffi = FFI::Platypus->new(
    api => 1,
    lib => [do {
      my $lib = FFI::CheckLib::find_lib lib => 'newrelic';
      $lib
        ? $lib
        : FFI::CheckLib::find_lib lib => 'newrelic', alien => 'Alien::libnewrelic',
    }],
  );

  FFI::C->ffi($ffi);

  package NewRelic::NewrelicLoglevel {
    FFI::C->enum([
      'error',
      'warning',
      'info',
      'debug',
    ], { prefix => 'NEWRELIC_LOG_' });
  }

  package NewRelic::NewrelicTransactionTracerThreshold {
    FFI::C->enum([
      'is_apdex_failing',
      'is_over_duration',
    ], { prefix => 'NEWRELIC_THRESHOLD_' });
  }

  package NewRelic::NewrelicTtRecordsql {
    FFI::C->enum([
      'off',
      'raw',
      'obfuscated',
    ], { prefix => 'NEWRELIC_SQL_' });
  }

  $ffi->type('uint64' => 'newrelic_time_us_t');

  package NewRelic::DatastoreReporting {
    FFI::C->struct([
      enabled      => 'bool',
      record_sql   => 'newrelic_tt_recordsql_t',
      threshold_us => 'newrelic_time_us_t',
    ]);
  };

  package NewRelic::NewrelicTransactionTracerConfig {
    FFI::C->struct([
      enabled                  => 'bool',
      threshold                => 'newrelic_transaction_tracer_threshold_t',
      duration_us              => 'newrelic_time_us_t',
      stack_trace_threshold_us => 'newrelic_time_us_t',
      datastore_reporting      => 'datastore_reporting_t',
    ]);
  }

  package NewRelic::NewrelicDatastoreSegmentConfig {
    FFI::C->struct([
      instance_reporting      => 'bool',
      database_name_reporting => 'bool',
    ]);
  }

  package NewRelic::NewrelicDistributedTracingConfig {
    FFI::C->struct([
      enabled => 'bool',
    ]);
  }

  package NewRelic::NewrelicSpanEventConfig {
    FFI::C->struct([
      enabled => 'bool',
    ]);
  }

  package NewRelic::NewrelicAppConfig {
    FFI::C->struct([
      app_name            => 'string(255)',
      license_key         => 'string(255)',
      redirect_collector  => 'string(100)',
      log_filename        => 'string(512)',
      log_level           => 'newrelic_loglevel_t',
      transaction_tracer  => 'newrelic_transaction_tracer_config_t',
      datastore_tracer    => 'newrelic_datastore_segment_config_t',
      distributed_tracing => 'newrelic_distributed_tracing_config_t',
      span_events         => 'newrelic_span_event_config_t',
    ], { trim_string => 1 });
  }

  package NewRelic::NewrelicApp {
    FFI::C->struct([
    ]);
  }

  sub _app_config {
    my($xsub, $app_name, $license_key) = @_;
    $app_name    //= $ENV{NEWRELIC_APP_NAME}    // 'AppName';
    $license_key //= $ENV{NEWRELIC_LICENSE_KEY} // '';
    $xsub->($app_name, $license_key);
  }

  sub _d1 ($) {
    my($name) = shift;
    my $class = 'NewRelic::' . ((ucfirst $name =~ s/_t$//r) =~ s/_([a-z])/uc($1)/egr);
    sub {
      my($xsub, $object) = @_;
      croak("Not a $name / $class")
        unless is_blessed_ref($object) && $object->isa("$class");
      my $ptr = delete $object->{ptr};
      croak("Already destroyed: $name / $class")
        unless defined $ptr;
      $xsub->(\$ptr);
    };
  }

  $ffi->attach( newrelic_create_app_config  => ['string','string']                  => 'newrelic_app_config_t', \&_app_config );
  $ffi->attach( newrelic_destroy_app_config => ['opaque*']                          => 'bool' => _d1('newrelic_app_config_t') );
  $ffi->attach( newrelic_configure_log      => ['string','newrelic_loglevel_t' ]    => 'bool'                                 );
  $ffi->attach( newrelic_init               => ['string','int' ]                    => 'bool'                                 );
  $ffi->attach( newrelic_create_app         => ['newrelic_app_config_t', 'ushort' ] => 'newrelic_app_t'                       );
  $ffi->attach( newrelic_destroy_app        => ['opaque*']                          => 'bool' => _d1('newrelic_app_t')        );
  $ffi->attach( newrelic_version            => []                                   => 'string'                               );

};

1;
