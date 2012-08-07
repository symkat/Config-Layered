package Config::Layered::Source::ENV;
use warnings;
use strict;
use Storable qw( dclone );

sub new {
    my ( $class, $layered, $args ) = @_;
    my $self = bless { layered => $layered, args => $args }, $class;
    return $self;
}

sub get_config {
    my ( $self ) = @_;

    my $struct = dclone($self->layered->default);
    my $config = {};

    for my $key ( keys %{$struct} ) {
        if ( exists $ENV{ "CONFIG_".uc($key) } ) {
            $config->{$key} = $ENV{ "CONFIG_" . uc($key) };
        }
    }

    return $config;
}

sub layered {
    return shift->{layered};
}

sub args {
    return shift->{args};
}

1;
