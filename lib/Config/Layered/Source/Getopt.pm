package Config::Layered::Source::Getopt;
use warnings;
use strict;

sub new {
    my ( $class, $layered, $args ) = @_;
    my $self = bless { layered => $layered, args => $args }, $class;
    return $self;
}

sub get_config {
    my ( $self ) = @_;
}

sub layered {
    return shift->{layered};
}

sub args {
    return shift->{args};
}

1;
