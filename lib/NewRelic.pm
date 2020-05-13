package NewRelic {

  use strict;
  use warnings;
  use 5.020;
  use NewRelic::FFI;
  use FFI::C 0.08;
  use base qw( Exporter );

# ABSTRACT: Unofficial Perl NewRelic SDK

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

=head1 FUNCTIONS

These may be imported on request using L<Exporter>.

=head2 newrelic_configure_log

 my $bool = newrelic_configure_log($filename, $level);

Configure the C SDK's logging system.  C<$level> should be one of:

=over 4

=item C<error>

=item C<warning>

=item C<info>

=item C<debug>

=back

(csdk: newrelic_configure_log)

=head2 newrelic_init

 my $bool = newrelic_init($daemon_socket, $time_limit_ms);

Initialize the C SDK with non-default settings.

(csdk: newrelic_init)

=head2 newrelic_version

 my $version = newrelic_version();

(csdk: newrelic_version)

Returns the

=cut

  $ffi->mangler(sub { $_[0] });
  $ffi->attach( newrelic_configure_log => ['string','newrelic_loglevel_t' ] => 'bool'   );
  $ffi->attach( newrelic_init          => ['string','int' ]                 => 'bool'   );
  $ffi->attach( newrelic_version       => []                                => 'string' );
  $ffi->mangler(sub { "newrelic_$_[0]" });

  our @EXPORT_OK = grep /^newrelic_/, keys %NewRelic::;

  require NewRelic::Config;
  require NewRelic::App;

};

1;

=head1 SEE ALSO

=over 4

=item L<NewRelic::App>

=item L<NewRelic::Config>

=item L<NewRelic::Segment>

=item L<NewRelic::Transaction>

=back

=cut
