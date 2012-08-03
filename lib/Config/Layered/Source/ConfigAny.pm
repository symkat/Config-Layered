package Config::Layered::Source::ConfigAny;
use warnings;
use strict;
use Config::Any;

sub new {
    my ( $class, $layered, $args ) = @_;
    my $self = bless { layered => $layered, args => $args }, $class;
    return $self;
}

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
}

sub layered {
    return shift->{layered};
}

sub args {
    return shift->{args};
}

1;
