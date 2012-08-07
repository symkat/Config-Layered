# NAME

Config::Layered::Source::ConfigAny - The Configuration File Source

# DESCRIPTION

The ConfigAny source provices access to running ConfigAny on a given
file stem.

# EXAMPLE

    my $config = Config::Layered->load_config( 
        sources => [ 'ConfigAny' => { file => "/etc/myapp" } ],
        default => {
            foo         => "bar",
            blee        => "baz",
            bax         => {
                chicken => "eggs",
            }
        }
    );



Provided a file `/etc/myapp` with the following content:

    foo: this
    bax:
        chicken: no-eggs
        pork:    chops

The following data structure in `$config` would be the result:

    {
        foo         => "this",
        blee        => "baz",
        bax         => {
            chicken => "no-eggs",
            pork    => "chops",
    }
    

# SOURCE ARGUMENTS

- file is a string which will be passed to Config::Any as a
file stem.

# GLOBAL ARGUMENTS

- file is a string which will be passed to Config::Any as a
file stem -- file as a source argument will take precedence.
