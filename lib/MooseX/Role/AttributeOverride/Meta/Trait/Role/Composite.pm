package MooseX::Role::AttributeOverride::Meta::Trait::Role::Composite;
# ABSTRACT: Support Role for L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>
use 5.008;
use utf8;
use Moose::Role;
use Moose::Util::MetaRole;

with 'MooseX::Role::AttributeOverride::Meta::Trait::Role';

around apply_params => sub {
    my $orig = shift;
    my $self = shift;
    $self->$orig(@_);

    ## no critic (ProhibitCallsToUnexportedSubs);

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

    ## use critic;

    for my $role (@{$self->get_roles}) {
        if ($role->can('attribute_modifiers')) {
            $self->add_modifiers_from_role($role);
        }
    }

    return $self;
};

no Moose::Role;
1; # Magic true value required at end of module
__END__

=head1 SYNOPSIS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 DESCRIPTION

Apply this role to composite roles.

=head1 DIAGNOSTICS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 DEPENDENCIES

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 INCOMPATIBILITIES

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 BUGS AND LIMITATIONS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

