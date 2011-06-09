package MyApp::Meta::Attribute;
use Moose::Role;

around _process_options => sub {
    my ( $orig, $class, $name, $options ) = @_;
   $options->{default} = sub { return 'yep' };  
     return $orig->($class , $name, $options);
};

around clone => sub {
    my $orig = shift;
    my $clone = $orig->(@_);
    $clone->{default} = sub { return 'yep' };   # Blah
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

use Test::More tests => 3;    # last test to print

my $test = MyApp->new();
my $attr = $test->meta->find_attribute_by_name('fun');

ok ( $attr->has_applied_traits, 'Traits get applied');

my $traits = $attr->applied_traits;
my $mytrait = 0;
if ($traits) {
    for (@{$traits}) {
        $mytrait += ($_ eq 'MyApp::Meta::Attribute') ? 1 : 0;
    }
}

ok ( $mytrait, 'My traits get applied');

#TODO:
#{
#    local $TODO = "This is a bug in moose (68698).";
    is( $test->fun, 'yep', "Default was set by role" );
#}


