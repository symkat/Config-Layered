# NAME

Config::Layered::Source::ENV - The Environment Variable Source

# DESCRIPTION

The ENV source provides configuration through environment variables.

For each top-level key in the default data structure, it checks for the
environment variable `CONFIG_$KEY` where $KEY is the name of the key used
in the default data structure.

# EXAMPLE

    my $config = Config::Layered->load_config( 
        default => {
            foo         => "bar",
            blee        => "baz",
            bax         => {
                chicken => "eggs",
            }
        }
    )

With the above configuration, the following keys will be checked:

- CONFIG\_FOO
- CONFIG\_BLEE
- CONFIG\_BAX

The following would \*NOT\* be checked:

- CONFIG\_CHICKEN

Given the above default data structure, a command run as 
`CONFIG_FOO="Hello World" ./myprogram` would result in a
`$config` structure like this:



    {
        foo         => "Hello World",
        blee        => "baz",
        bax         => {
            chicken => "eggs",
    }

# SOURCE ARGUMENTS

- params is an array ref of keys to check Default: Keys of the default
data structure.
- prefix is a word prepended to your key that is used to check 
`$ENV{$prefix . "_" . uc($key) }`.

Example:

    Config::Layered->load_config(
        sources => [ 
            'ENV' => { prefix => "MYAPP", params => [qw( bar blee )] } 
        ],
        default => { debug => 0, verbose => 1 },
    );

The following keys would be checked:

                - MYAPP\_BAR
            - MYAPP\_BLEE
        - MYAPP\_DEBUG
    - MYAPP\_VERBOSE
