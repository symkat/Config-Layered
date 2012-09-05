#!/usr/bin/perl
use warnings;
use strict;
use Config::Layered;
use Test::More;

my $tests = [
    {
        put => { verbose => 1, run => 0, value => "[% verbose %]" },
        argv => [ qw( ) ],
        get => { verbose => 1, run => 0, value => 1 },
        title => "Flags - Change Neither",
    },
    {
        put => { verbose => 1, run => 0, value => "[% run %]" },
        argv => [ qw( --run --noverbose ) ],
        get => { verbose => 0, run => 1, value => 1 },
        title => "Flags - Change Both",
    },
    {
        put => { verbose => 1, run => 0, value => "[% verbose %] [% run %]" },
        argv => [ qw( --noverbose ) ],
        get => { verbose => 0, run => 0, value => "0 0" },
        title => "Flags - Change One",
    },
    {
        put => { verbose => 1, run => 0, value => "[% verbose %][% run %]" },
        argv => [ qw( --norun --verbose ) ],
        get => { verbose => 1, run => 0, value => "10" },
        title => "Flags - Same Set",
    },
    {
        put => { verbose => "yes", run => "no", value => "[% verbose %][% run %]" },
        argv => [ qw() ],
        get => { verbose => "yes", run => "no", value => "yesno" },
        title => "Strings -- Change Neither",
    },
    {
        put => { verbose => "yes", run => "no", value => "[% verbose %][% run %]" },
        argv => [ qw( --verbose no ) ],
        get => { verbose => "no", run => "no", value => "nono"},
        title => "Strings -- Change One",
    },
    {
        put => { verbose => "yes", run => "no", value => "[% verbose %][% run %]" },
        argv => [ qw( --verbose no --run yes ) ],
        get => { verbose => "no", run => "yes", value => "noyes" },
        title => "Strings -- Change Both",
    },
    {
        put => { verbose => "yes", run => "no", value => "[% verbose %][% run %]" },
        argv => [ qw( --verbose yes --run no) ],
        get => { verbose => "yes", run => "no", value => "yesno"},
        title => "Strings -- Same Set",
    },
    {
        put => { verbose => 1, run => "yes", value => "[% verbose %][% run %]" },
        argv => [ qw() ],
        get => { verbose => 1, run => "yes", value => "1yes" },
        title => "Flags + Strings -- Change Neither",
    },
    {
        put => { verbose => 0, run => "yes",  value => "[% verbose %][% run %]" },
        argv => [ qw( --verbose --run no) ],
        get => { verbose => 1, run => "no", value => "1no" },
        title => "Flags + Strings -- Change Both",
    },
    {
        put => { verbose => 1, run => "yes", value => "[% verbose %][% run %]" },
        argv => [ qw( --run no ) ],
        get => { verbose => 1, run => "no", value => "1no" },
        title => "Flags + Strings -- Change One",
    },
];

for my $test ( @$tests ) {
    # Change ENV Vars...
    for my $key ( keys %{$test->{put}} ) {
        $ENV{ "CONFIG_" . uc($key)} = $test->{put}->{$key};
    }

    # Change ARGV
    @ARGV = @{ $test->{argv} };

    # This test will set the defaults for ENV... and expect them to
    # be filled fro $ENV.
    is_deeply( 
        Config::Layered->load_config( 
            default => { map { $_ => "" } keys %{$test->{put}} }, 
            sources => [ 'ENV', 'Getopt' ],
        ), 
        $test->{get}, 
        $test->{title});
}

done_testing;
