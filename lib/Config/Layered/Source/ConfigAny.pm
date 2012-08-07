package Config::Layered::Source::ConfigAny;
use warnings;
use strict;
use Config::Any;
use parent 'Config::Layered::Source';

sub get_config {
    my ( $self ) = @_;

    my $file = $self->args->{file};
    $file = $self->layered->{file} unless $file;

    return {} unless defined $file;

    my $config = Config::Any->load_stems( { 
        stems => [ $file ],
        use_ext => 1, 
    });
        
    return $config->[0]->{ (keys %{$config->[0]})[0] }
        if @{$config} == 1;

    return {}; # If we couldn't load a config file.
}

1;
