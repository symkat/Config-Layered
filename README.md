# NAME

Config::Layered - Layered config from files, command line, and other sources.

# DESCRIPTION

Config::Layered aims to make it easy for programmers, operations teams and those
who run the programs to have the configuration methods they prefer with one simple
interface.

By default options will be taken from the program source code itself, then
\-- if provided -- a configuration file, and finally command-line options.

# SYNOPSIS

By default options will be taken from the program source code itself, then
\-- if provided -- a configuration file, and finally command-line options.

    my $config = Config::Layered->load_config(
        file         => "/etc/myapp",
        default => {
            verbose => 0,
            run             => 1,
            input           => "/tmp/to_process",
            output          => "/tmp/done_processing",
            plugins         => [ qw( process ) ] 
        },
    );

Given the above, the data structure would look like:

    TODO

Provided a file, `/etc/myapp.yml` with the line `input: /tmp/pending_process` 
the data structure would look like:

    TODO

Provided the command line arguments `--norun --verbose --output /tmp/completed_process`
the data structure would look like:

    TODO

# METHODS

## load\_config

- file

By default the file given here will be loaded by Config::Any and the data
structure provided will be merged ontop of the default data structure.

Example:

    file => "/etc/myapp",

This will atempt to load `/etc/myapp` as a stem in [Config::Any](http://search.cpan.org/perldoc?Config::Any), meanig
files like `/etc/myapp.yml`, `/etc/myapp.conf`, `/etc/myapp.ini` and such
will be checked for existence.

- default

This is the default data structure that [Config::Layered](http://search.cpan.org/perldoc?Config::Layered) will load.

Example:

    default => {
        verbose => 1,
        run     => 0,
    },

The above data structure will have `$config->{verbose}` set to 1, and
`$config->{run}` set to 0 if there are no configuration files, and no
command line options used.

- sources

A source returns an instance of configuration to merge with previously loaded
sources.  Following a source a specific configuration may be sent the to source.

Example

    sources => [ 'ConfigAny', { file => "/etc/myapp }, 'Getopts' ]

In the above example, [Config::Layered::Sources::ConfigAny](http://search.cpan.org/perldoc?Config::Layered::Sources::ConfigAny) will be loaded,
and the following hashref will be sent to the source.  This allows source-specific
configuration to be used.  For more information on creating a soure, see
["CREATING A SOURCE"](#CREATING A SOURCE).

- merge\_method

You may provide a method as a coderef that will be used to merge the data
structures returned from a source together.  By default the method used favors
the newer sources that are loaded.

# CREATING A SOURCE

If you would like to create your own source to provide a configuration method,
the following documents the creation of a source.  You can also check
[Config::Layered::Source::ConfigAny](http://search.cpan.org/perldoc?Config::Layered::Source::ConfigAny) for a source that is used by default.

## WRITING THE SOURCE CLASS

A source requires at least two methods, `new` and `get_config`.

- new

The `new` method should take the following arguments and return an instance of itself:

`$caller` is the instance of [Config::Layered](http://search.cpan.org/perldoc?Config::Layered) which called it.  You may look at all
arguments given at construction of the instance.

`$arguments` is the source-specific configuration information.  You should __NOT__ parse
`$config->sources` yourself, instead look at `$arguments`, and optionally fall-back
to using information in `$caller` to make decisions.

    sub new {
        my ( $class, $caller, $args ) = @_;
        my $self = bless { caller => $caller, args => $args }, $class;
        return $self;
    }

- get\_config

The `get_config` method is given no arguments, and expected to return a hashref that
is merged with previous sources, and will be merged over by future sources.

Example:

    sub get_config {
        my ( $self ) = @_;
        

        # Load a specific file with Config::Any
        if ( exists $self->{args}->{file} ) {
            return Config::Any->load_file( { file => $self->{args}->{file} );
        # Otherwise, load the global file with Config::Any
        } elsif ( exists $config->{caller}->{file} ) 
            return Config::Any->load_file( { file => $self->{caller}->{file} );
        }
        # No configuration file, our source is being ignored.
        return {};
    }

## GLOBAL OR SOURCE ARGUMENTS?

Config::Layered will accept any constructor arguments and a source may
look at `$caller` to check them.  However, source instance specific arguments
are also available.  Both should be supported under the following reasoning:

Suppose that I would like to load a global file, but I would also like to merge arguments
from a configuration file in my home directory.  With only global arguments this isn't 
possible.  With source-specific arguments, this is easily enabled:

    my $config = Config::Layered->get_config( 
        sources => [ 
            'ConfigAny', { file => "/etc/myapp" },
            'ConfigAny', { file => $ENV{"HOME"} . "/.myapp",
        ] ,
    );

Global arguments are useful in the context that writing out the data structure for the
default use-cases and single-use sources can be tedious.

# AUTHOR

- Kaitlyn Parkhurst (SymKat) _<symkat@symkat.com>_ ([http://symkat.com/](http://symkat.com/))

# CONTRIBUTORS

# COPYRIGHT

Copyright (c) 2012 the Config::Layered ["AUTHOR"](#AUTHOR) and ["CONTRIBUTORS"](#CONTRIBUTORS) as listed
above.

# LICENSE

This library is free software and may be distributed under the same terms as 
perl itself.

# AVAILABILITY

The latest version of this software is available at 
[https://github.com/symkat/Config-Layered](https://github.com/symkat/Config-Layered)
