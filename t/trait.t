package MyApp::Meta::Attribute;
use Moose::Role;

around _process_options => sub {
    my ( $orig, $class, $name, $options ) = @_;
   $options->{default} = sub { return 'yep' };  
     return $orig->($class , $name, $options);
};


package MyApp::Role;
use Moose::Role;
use MooseX::Role::AttributeOverride;

has_plus 'fun' => ( traits => ['MyApp::Meta::Attribute'] );

no Moose::Role;

package MyApp;
use Moose;

has 'fun' => (
    is  => 'rw',
    isa => 'Str'
);

with qw(MyApp::Role);

__PACKAGE__->meta->make_immutable;
no Moose;

package main;

#use MyApp;

use Test::More tests => 1;    # last test to print

my $test = MyApp->new();

is( $test->fun, 'yep', "Default was set by role" );

