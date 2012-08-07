# NAME

Config::Layered::Source::Getopt - The Command Line Source

# DESCRIPTION

The Getopt source provides access to Getopt::Long and will configure
it based on the default data structure.

The configuration of the Getopt::Long options is done in the following
way:

- If the default value of a key is 0 or 1, it is treated as
a boolean, and the `key!` directive is used.  This will enable `--no*` 
options to work as expected.
- If the value is a hash reference, the `key%` directive is used,
and options are configured as `--key name=value`.  New hash keys will
be added, previously used hash keys (i.e. default configuration, previously
run sources) will be replaced.
- If the value if an array reference, the `key@` directive is used,
and options are configured as `--key value --key value`.  An array entered
by this source will replace a previously entered array (i.e. default
configuration, previous run sources).
- All other situations will result in a simple string, `key=s`.

# EXAMPLE

    my $config = Config::Layered->load_config( 
        sources => [ 'ConfigAny' => { file => "/etc/myapp" } ],
        default => {
            foo         => "bar",
            blee        => 1,
            size        => 20,
            bax         => { chicken => "eggs", }
            baz         => [ wq( foo bar blee ) ]
        }
    );

The above data structure would create the following Getopt::Long 
configuration:

    Getopts( \%config,
        "foo=s",
        "blee!",
        "size",
        "bax%",
        "baz@",
    );
    

# SOURCE ARGUMENTS

    - None
