package Config::Layered::Source::Getopt;
use warnings;
use strict;
use Storable qw( dclone );
use Getopt::Long;
use Scalar::Util qw( looks_like_number );
use parent 'Config::Layered::Source';

sub get_config {
    my ( $self ) = @_;
    my @want;

    my $struct = dclone($self->layered->default);

    for my $key ( keys %{$struct} ) {
        if ( ref $struct->{$key} eq 'ARRAY' ) {
            push @want, "$key=s@";
        } elsif ( ref $struct->{$key} eq 'HASH' ) {
            push @want, "$key=s%"
        } elsif ( _is_bool($struct->{$key}) ) {
            push @want, "$key!";
        } else {
            push @want, "$key=s";
        }
    }

    my %config;
    GetOptions( \%config, @want );
    return { %config };
}

sub _is_bool {
    my ( $any ) = @_;
    return 0 unless looks_like_number($any);
    return 1 if $any == 1;
    return 1 if $any == 0;
    return 0;
}

1;
