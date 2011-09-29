package Facebook::Graph::Publish::CustomAction;

use Facebook::Graph;
BEGIN {
  $Facebook::Graph::Publish::CustomAction::VERSION = '0.0001';
}

use Any::Moose;
use DateTime;
use DateTime::Format::Strptime;

extends 'Facebook::Graph::Publish';

has start_time => (
    is          => 'rw',
    isa         => 'DateTime',
    predicate   => 'has_start_time',
);

sub set_start_time {
    my ($self, $start_time) = @_;
    $self->start_time($start_time);
    return $self;
}

has end_time => (
    is          => 'rw',
    isa         => 'DateTime',
    predicate   => 'has_end_time',
);

sub set_end_time {
    my ($self, $end_time) = @_;
    $self->end_time($end_time);
    return $self;
}

has expires_in => (
    is          => 'rw',
    predicate   => 'has_expires_in',
);

sub set_expires_in {
    my ($self, $expires_in) = @_;
    $self->expires_in($expires_in);
    return $self;
}

has place => (
    is          => 'rw',
    predicate   => 'has_place',
);

sub set_place {
    my ($self, $value) = @_;
    $self->place($value);
    return $self;
}

has images => (
    is          => 'rw',
    isa         => 'ArrayRef',
    predicate   => 'has_images',
    lazy        => 1,
    default     => sub {[]},
);

sub set_images {
    my ($self, $value) = @_;
    $self->images($value);
    return $self;
}

has tags => (
    is          => 'rw',
    isa         => 'ArrayRef',
    predicate   => 'has_tags',
    lazy        => 1,
    default     => sub {[]},
);

sub set_tags {
    my ($self, $value) = @_;
    $self->tags($value);
    return $self;
}

has reference => (
    is          => 'rw',
    predicate   => 'has_reference',
);

sub set_reference {
    my ($self, $reference) = @_;
    $self->reference($reference);
    return $self;
}


has message => (
    is          => 'rw',
    predicate   => 'has_message',
);

sub set_message {
    my ($self, $message) = @_;
    $self->message($message);
    return $self;
}

around get_post_params => sub {
    my ($orig, $self) = @_;
    my $post = $orig->($self);
    
    my $strp = DateTime::Format::Strptime->new(pattern => '%FT %T%z');

    push @$post, start_time => $strp->format_datetime($self->start_time)
        if $self->has_start_time;

    push @$post, end_time => $strp->format_datetime($self->end_time)
        if $self->has_end_time;
    
    push @$post, expires_in => $self->expires_in
        if $self->has_expires_in;
    
    push @$post, place => $self->place
        if $self->has_place;
    
    push @$post, images => join(', ',@{$self->images})
        if $self->has_images;
    
    push @$post, tags => join(', ',@{$self->tags})
        if $self->has_tags;
    
    push @$post, ref => $self->reference
        if $self->has_reference;
    
    push @$post, message => $self->message
        if $self->has_message;
        
    return $post;
};

1;
