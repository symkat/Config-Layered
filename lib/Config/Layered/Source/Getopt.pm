package Config::Layered::Source::Getopt;
use warnings;
use strict;
use Storable qw( dclone );
use Getopt::Long;
use Scalar::Util qw( looks_like_number );

sub new {
    my ( $class, $layered, $args ) = @_;
    my $self = bless { layered => $layered, args => $args }, $class;
    return $self;
}

sub get_config {
    my ( $self ) = @_;
    my @want;

    my $struct = dclone($self->layered->default);

    for my $key ( keys %{$struct} ) {
        if ( ref $struct->{$key} eq 'ARRAY' ) {
            push @want, "$key=s@";
        } elsif ( ref $struct->{$key} eq 'HASH' ) {
            push @want, "$key=s%"
        } elsif ( looks_like_number($struct->{$key}) && ( $struct->{$key} == 1 or $struct->{$key} == 0 ) )  {
            push @want, "$key!";
        } else {
            push @want, "$key=s";
        }
    }

    my %config;
    GetOptions( \%config, @want );
    return { %config };
}

sub layered {
    return shift->{layered};
}

sub args {
    return shift->{args};
}

1;
