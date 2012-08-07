package Config::Layered::Source::ENV;
use warnings;
use strict;
use Storable qw( dclone );
use parent 'Config::Layered::Source';

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

1;
