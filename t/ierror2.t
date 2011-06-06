package MyApp::Role;
use Moose::Role;
use MooseX::Role::AttributeOverride;

has_plus 'fun' => (
    default                 => 'yep',
    override_ignore_missing => 1,
);

no Moose::Role;

package MyApp;
use Moose;

has 'notfun' => (
    is  => 'rw',
    isa => 'Str'
);

no Moose;

package main;
use Moose::Util;

use Test::More tests => 1;    # last test to print

eval {
    Moose::Util::apply_all_roles( 'MyApp', 'MyApp::Role' );
    MyApp->meta->make_immutable;
    my $test = MyApp->new();
};
my $error = $@;

ok( !$error, 'Missing Attribute does not die' );

