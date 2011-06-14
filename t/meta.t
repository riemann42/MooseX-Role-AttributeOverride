use strict;
use warnings;

{

    package MyApp::Trait;
    use Moose::Role;
    use MooseX::Role::AttributeOverride;

    has_plus 'default' => ( default => sub { return time } );

}
{

    package MyApp;
    use Moose;

    has 'fun' => (
        is     => 'rw',
        isa    => 'Int',
        traits => ['MyApp::Trait'],
    );

    __PACKAGE__->meta->make_immutable;
    no Moose;

}
{

    package main;

    #use MyApp;

    use Test::More tests => 1;    # last test to print

    my $time = time;
    my $test = MyApp->new();

    cmp_ok( $test->fun, '>=', $time, "Value was set by sub" );

}
