package LoginSample::Plugin::MongoDB;
use strict;
use warnings;
use utf8;

use MongoDB;

sub init {
    my ($class, $context_class, $config) = @_;

    no strict 'refs';
    *{"$context_class\::mongo"} = \&_mongo;
}

sub _mongo {
    my ($self) = @_;

    if ( !defined $self->{mongo} ) {
        my $conf = $self->config->{'MongoDB'}
            or die "missing configuration for 'MongoDB'";
        my $dbname = $conf->{database}
            or die "missing 'MongoDB.database'";

        my $host = $conf->{host} || 'localhost';
        my $port = $conf->{port} || 'port';

        my $conn = MongoDB::Connection->new(host => "$host:$port");
        $self->{mongo} = $conn->get_database($dbname);
    }
    return $self->{mongo};
}

1;

__END__

__PACKAGE__->load_plugin(qw/MongoDB/);

$c->mongo->users->find();
