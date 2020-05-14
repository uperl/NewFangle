package NewFangle {

  use strict;
  use warnings;
  use 5.020;
  use NewFangle::FFI;
  use FFI::C 0.08;
  use base qw( Exporter );

# ABSTRACT: Unofficial Perl NewRelic SDK

=head1 SYNOPSIS

 use NewRelic;
 my $app = NewRelic::App->new('MyApp', $license_key);
 my $txn = $app->start_transaction('my transaction');
 $txn->end;

=head1 DESCRIPTION

This module provides bindings to the NewRelic C-SDK.  Since NewRelic doesn't provide
native Perl bindings for their product, and the older Agent SDK is not supported,
this is probably the best way to instrument your Perl application with NewRelic.

This distribution provides a light OO interface using L<FFI::Platypus> and will
optionally use L<Alien::libnewrelic> if the C-SDK can't be found in your library
path.  Unfortunately the naming convention used by NewRelic doesn't always have an
obvious mapping to the OO Perl interface, so I've added notation (example:
(csdk: newrelic_version)) so that the C version of functions and methods can be
found easily.  The documentation has decent coverage of all methods, but it doesn't
always make sense to reproduce everything that is in the C-SDK documentation, so
it is recommended that you review it before getting started.

I've called this module L<NewFangle> in the hopes that one day NewRelic will write
native Perl bindings and they can use the more obvious NewRelic namespace.

=cut

  FFI::C->ffi($ffi);

  package NewFangle::NewrelicLoglevel {
    FFI::C->enum([
      'error',
      'warning',
      'info',
      'debug',
    ], { prefix => 'NEWRELIC_LOG_' });
  }

  package NewFangle::NewrelicTransactionTracerThreshold {
    FFI::C->enum([
      'is_apdex_failing',
      'is_over_duration',
    ], { prefix => 'NEWRELIC_THRESHOLD_' });
  }

  package NewFangle::NewrelicTtRecordsql {
    FFI::C->enum([
      'off',
      'raw',
      'obfuscated',
    ], { prefix => 'NEWRELIC_SQL_' });
  }

  $ffi->type('uint64' => 'newrelic_time_us_t');

  package NewFangle::DatastoreReporting {
    FFI::C->struct([
      enabled      => 'bool',
      record_sql   => 'newrelic_tt_recordsql_t',
      threshold_us => 'newrelic_time_us_t',
    ]);
  };

  package NewFangle::NewrelicTransactionTracerConfig {
    FFI::C->struct([
      enabled                  => 'bool',
      threshold                => 'newrelic_transaction_tracer_threshold_t',
      duration_us              => 'newrelic_time_us_t',
      stack_trace_threshold_us => 'newrelic_time_us_t',
      datastore_reporting      => 'datastore_reporting_t',
    ]);
  }

  package NewFangle::NewrelicDatastoreSegmentConfig {
    FFI::C->struct([
      instance_reporting      => 'bool',
      database_name_reporting => 'bool',
    ]);
  }

  package NewFangle::NewrelicDistributedTracingConfig {
    FFI::C->struct([
      enabled => 'bool',
    ]);
  }

  package NewFangle::NewrelicSpanEventConfig {
    FFI::C->struct([
      enabled => 'bool',
    ]);
  }

  package NewFangle::NewrelicAppConfig {
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

  our @EXPORT_OK = grep /^newrelic_/, keys %NewFangle::;

  require NewFangle::Config;
  require NewFangle::App;
  require NewFangle::CustomEvent;

};

1;

=head1 CAVEATS

Unlike the older NewRelic Agent SDK, there is no interface to set the programming
language or version.  Since we are using the C-SDK the language shows up as C<C>
instead of C<Perl>.

=head1 SEE ALSO

=over 4

=item L<NewFangle::App>

=item L<NewFangle::Config>

=item L<NewFangle::CustomEvent>

=item L<NewFangle::Segment>

=item L<NewFangle::Transaction>

=back

=cut
