# NewRelic [![Build Status](https://travis-ci.org/plicease/NewRelic.svg)](http://travis-ci.org/plicease/NewRelic)

Unofficial Perl NewRelic SDK

# SYNOPSIS

```perl
use NewRelic;
my $app = NewRelic::App->new('MyApp', $license_key);
my $txn = $app->start_transaction('my transaction');
$txn->end;
```

# DESCRIPTION

This module provides bindings to the NewRelic C-SDK.  Since NewRelic doesn't provide
native Perl bindings for their product, and the older Agent SDK is not supported,
this is probably the best way to instrument your Perl application with NewRelic.

This distribution provides a light OO interface using [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus) and will
optionally use [Alien::libnewrelic](https://metacpan.org/pod/Alien::libnewrelic) if the C-SDK can't be found in your library
path.  Unfortunately the naming convention used by NewRelic doesn't always have an
obvious mapping to the OO Perl interface, so I've added notation (example:
(csdk: newrelic\_version)) so that the C version of functions and methods can be
found easily.  The documentation has decent coverage of all methods, but it doesn't
always make sense to reproduce everything that is in the C-SDK documentation, so
it is recommended that you review it before getting started.

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

# CAVEATS

Unlike the older NewRelic Agent SDK, there is no interface to set the programming
language or version.  Since we are using the C-SDK the language shows up as `C`
instead of `Perl`.

# SEE ALSO

- [NewRelic::App](https://metacpan.org/pod/NewRelic::App)
- [NewRelic::Config](https://metacpan.org/pod/NewRelic::Config)
- [NewRelic::Segment](https://metacpan.org/pod/NewRelic::Segment)
- [NewRelic::Transaction](https://metacpan.org/pod/NewRelic::Transaction)

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
