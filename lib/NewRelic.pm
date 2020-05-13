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
  use base qw( Exporter );

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

=head1 FUNCTIONS

These may be imported on request using L<Exporter>.

=head2 newrelic_configure_log

 my $bool = newrelic_configure_log($filename, $level);

Configure the C SDK's logging system.  (See C<newrelic_configure_log>)

=head2 newrelic_init

 my $bool = newrelic_init($daemon_socket, $time_limit_ms);

Initialize the C SDK with non-default settings.  (See C<newrelic_init>)

=head2 newrelic_version

 my $version = newrelic_version();

Returns the

=cut


  $ffi->attach( newrelic_configure_log    => ['string','newrelic_loglevel_t' ]    => 'bool'                                 );
  $ffi->attach( newrelic_init             => ['string','int' ]                    => 'bool'                                 );
  $ffi->attach( newrelic_version          => []                                   => 'string'                               );

  our @EXPORT_OK = grep /^newrelic_/, keys %NewRelic::;

  $ffi->mangler(sub { "newrelic_$_[0]" });

  #$ffi->attach( create_app         => ['newrelic_app_config_t', 'ushort' ] => 'newrelic_app_t'                       );
  #$ffi->attach( destroy_app        => ['opaque*']                          => 'bool' => _d1('newrelic_app_t')        );

  package NewRelic::Config {

    $ffi->attach( [ create_app_config => 'new' ] => [ 'string', 'string' ] => 'newrelic_app_config_t' => sub {
      my($xsub, $class, %config) = @_;
      my $app_name    = delete $config{app_name}    // $ENV{NEWRELIC_APP_NAME}    // 'AppName';
      my $license_key = delete $config{license_key} // $ENV{NEWRELIC_LICENSE_KEY} // '';
      my $config = $xsub->($app_name, $license_key);
      FFI::C::Util::perl_to_c($config, \%config);
      bless {
        config => $config,
      }, $class;
    });

    sub to_perl
    {
      my($self) = @_;
      FFI::C::Util::c_to_perl($self->{config});
    }

    $ffi->attach( [ destroy_app_config => 'DESTROY' ] => [ 'opaque*' ] => 'bool' => sub {
      my($xsub, $self) = @_;
      my $ptr = delete $self->{config}->{ptr};
      $xsub->(\$ptr);
    });
  }

};

1;
