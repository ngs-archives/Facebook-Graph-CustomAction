package Facebook::Graph::Publish::Ngsdevorg::Listen;

use Facebook::Graph;
BEGIN {
  $Facebook::Graph::Publish::Ngsdevorg::Listen::VERSION = '0.0001';
}

use Any::Moose;
extends 'Facebook::Graph::Publish::CustomAction';

use constant object_path => '/ngsdevorg:listen';

has music_uri => (
    is          => 'rw',
    predicate   => 'has_music_uri',
);

sub set_music_uri {
    my ($self, $music_uri) = @_;
    $self->music_uri($music_uri);
    return $self;
}

sub _add_listen {
    my ($self, $object_name) = @_;
    my %params;
    if ($object_name) {
        $params{object_name} = $object_name;
    }
    if ($self->has_access_token) {
        $params{access_token} = $self->access_token;
    }
    if ($self->has_secret) {
        $params{secret} = $self->secret;
    }
    return Facebook::Graph::Publish::Ngsdevorg::Listen->new( %params );
}

around get_post_params => sub {
    my ($orig, $self) = @_;
    my $post = $orig->($self);
    push @$post, music => $self->music_uri if $self->has_music_uri;
    return $post;
};

*Facebook::Graph::add_listen = \&_add_listen;

1;
