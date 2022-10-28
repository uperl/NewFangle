# NewFangle ![linux](https://github.com/uperl/NewFangle/workflows/linux/badge.svg) ![macos](https://github.com/uperl/NewFangle/workflows/macos/badge.svg)

Unofficial Perl NewRelic SDK

# SYNOPSIS

```perl
use NewFangle;
my $app = NewFangle::App->new({app_name => 'MyApp', license_key => $license_key});
my $txn = $app->start_web_transaction('my transaction');
$txn->end;
```

Or using a [NewFangle::Config](https://metacpan.org/pod/NewFangle::Config):

```perl
use NewFangle;
my $config = NewFangle::Config->new(
  app_name => 'MyApp',
  license_key => $license_key,
);
my $app = NewFangle::App->new($config);
my $txn = $app->start_web_transaction('my transaction');
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

This module requires a running `newrelic-daemon`.  If you forget, the service `newrelic-infra` will return an initialization diagnostic like this:

```
2021-05-27 06:41:27.160 +0000 (23284 23284) error: failed to connect to the daemon using a timeout of 0 ms at the path /tmp/.newrelic.sock
2021-05-27 06:41:27.160 +0000 (23284 23284) error: error initialising libnewrelic; cannot create application
```

I've called this module [NewFangle](https://metacpan.org/pod/NewFangle) in the hopes that one day NewRelic will write
native Perl bindings and they can use the more obvious NewRelic namespace.

<div>
    <p>On your dashboard side, you will get:</p>
    <div style="display: flex">
    <div style="margin: 3px; flex: 1 1 50%">
    <img alt="Test" src="/newrelic-dashboard-result.png" style="max-width: 100%">
    </div>
    </div>
</div>

# FUNCTIONS

These may be imported on request using [Exporter](https://metacpan.org/pod/Exporter).

For instance:

```perl
use NewFangle qw( newrelic_init );
```

## newrelic\_configure\_log

```perl
my $bool = newrelic_configure_log($filename, $level);
```

Configure the C SDK's logging system.  If the literal string `stdout` 
or `stdout` is specified for `$filename`, then the logs will be 
written to standard output or standard error, respectively.  `$level` 
should be one of:

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

Returns the version of the NewRelic C-SDK as a string.

## newrelic\_set\_hostname

```perl
my $bool = newrelic_set_hostname($hostname);
```

Sets the default hostname to be used in the NewRelic UI.  This is the result of
`gethostname` by default, but that might not be usefully meaningful when running in
a docker or similar container.

This requires a properly patched NewRelic C-SDK to work, since the base C-SDK doesn't
currently support overriding the hostname.  If you installed with [Alien::libnewrelic](https://metacpan.org/pod/Alien::libnewrelic)
then it should have been properly patched for you.

Returns true if successful, false otherwise.  Normally a failure would only happen if
the NewRelic C-SDK hadn't been patched.

# ENVIRONMENT

- `NEWRELIC_APP_NAME`

    The default app name, if not specified in the configuration.

- `NEWRELIC_LICENSE_KEY`

    The NewRelic license key.

- `NEWRELIC_APP_HOSTNAME`

    The host display name that will be reported to NewRelic, if the `libnewrelic` has been properly
    patched (see `newrelic_set_hostname` above).

# CAVEATS

Unlike the older NewRelic Agent SDK, there is no interface to set the programming
language or version.  Since we are using the C-SDK the language shows up as `C`
instead of `Perl`.

# SEE ALSO

- [NewFangle::App](https://metacpan.org/pod/NewFangle::App)
- [NewFangle::Config](https://metacpan.org/pod/NewFangle::Config)
- [NewFangle::CustomEvent](https://metacpan.org/pod/NewFangle::CustomEvent)
- [NewFangle::Segment](https://metacpan.org/pod/NewFangle::Segment)
- [NewFangle::Transaction](https://metacpan.org/pod/NewFangle::Transaction)

# AUTHOR

Author: Graham Ollis <plicease@cpan.org>

Contributors:

Owen Allsopp (ALLSOPP)

# COPYRIGHT AND LICENSE

This software is copyright (c) 2020-2022 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
