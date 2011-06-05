package MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToClass;

BEGIN {
    $MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToClass::VERSION = '0.10';
}
use Moose::Role;

around apply => sub {
    my $orig = shift;
    my $self = shift;
    my ( $role, $class ) = @_;

    if ( $role->can('_attribute_modifiers') ) {
        $role->_apply_modifiers($class);
    }

    $self->$orig( $role, $class );
};

no Moose::Role;

1;
