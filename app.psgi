use strict;
use warnings;
use utf8;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'extlib', 'lib', 'perl5');
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use Amon2::Lite;

use Data::Dumper;

our $VERSION = '0.13';

# put your configuration here
sub load_config {
    my $c = shift;

    my $mode = $c->mode_name || 'development';

    +{
        'DBI' => [
            "dbi:SQLite:dbname=$mode.db",
            '',
            '',
        ],
        'MongoDB' => {
            database => 'sample',
            host     => 'localhost',
            port     => '27017',
        },
    }
}

get '/' => sub {
    my $c = shift;
    $c->mongo->get_collection('thing')->insert({unko => 'unkounkounko'});
    return $c->render('index.tt');
};

# load plugins
__PACKAGE__->load_plugin('Web::CSRFDefender' => {
    post_only => 1,
});
__PACKAGE__->load_plugin('+LoginSample::Plugin::MongoDB');
__PACKAGE__->load_plugin('Web::FillInFormLite');
__PACKAGE__->load_plugin('Web::JSON');

__PACKAGE__->enable_session();

__PACKAGE__->to_app(handle_static => 1);

__DATA__

@@ index.tt
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>LoginSample</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="[% uri_for('/static/js/main.js') %]"></script>
    <link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css" rel="stylesheet">
    <script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="[% uri_for('/static/css/main.css') %]">
</head>
<body>
    <div class="container">
        <header><h1>LoginSample</h1></header>
        <section class="row">
            This is a LoginSample
        </section>
        <footer>Powered by <a href="http://amon.64p.org/">Amon2::Lite</a></footer>
    </div>
</body>
</html>

@@ /static/js/main.js

@@ /static/css/main.css
footer {
    text-align: right;
}
