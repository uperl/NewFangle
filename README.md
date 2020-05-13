# NewRelic [![Build Status](https://travis-ci.org/plicease/NewRelic.svg)](http://travis-ci.org/plicease/NewRelic)

Unofficial Perl NewRelic SDK

# FUNCTIONS

These may be imported on request using [Exporter](https://metacpan.org/pod/Exporter).

## newrelic\_configure\_log

```perl
my $bool = newrelic_configure_log($filename, $level);
```

Configure the C SDK's logging system.  `$level` should be one of:

- `error`
- `warning`
- `info`
- `debug`

(csdk: newrelic\_configure\_log)

## newrelic\_init

```perl
my $bool = newrelic_init($daemon_socket, $time_limit_ms);
```

Initialize the C SDK with non-default settings.

(csdk: newrelic\_init)

## newrelic\_version

```perl
my $version = newrelic_version();
```

(csdk: newrelic\_version)

Returns the

# SEE ALSO

- [NewRelic::App](https://metacpan.org/pod/NewRelic::App)
- [NewRelic::Config](https://metacpan.org/pod/NewRelic::Config)
- [NewRelic::Transaction](https://metacpan.org/pod/NewRelic::Transaction)

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
