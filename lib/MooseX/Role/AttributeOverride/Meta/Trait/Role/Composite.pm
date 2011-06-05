package MooseX::Role::AttributeOverride::Meta::Trait::Role::Composite;
use Moose::Role;
with 'MooseX::Role::AttributeOverride::Meta::Trait::Role';

around apply_params => sub {
    my $orig = shift;
    my $self = shift;


    $self->$orig(@_);
    $self = Moose::Util::MetaRole::apply_metaroles(
        for            => $self,
        role_metaroles => {
            role =>
                ['MooseX::Role::AttributeOverride::Meta::Trait::Role'],
            application_to_class =>
                ['MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToClass'],
            application_to_role =>
                ['MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToRole'],
            },
    );

    for my $role (@{$self->get_roles}) {
        if ($role->can('_attribute_modifiers')) {
            $self->_add_additional_role($role);
        }
    }

    return $self;
};

no Moose::Role;

1;
