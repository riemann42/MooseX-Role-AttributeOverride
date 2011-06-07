package MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToRole;
# ABSTRACT: Support Role for L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>
use 5.008;
use utf8;
use Moose::Role;
use Moose::Util::MetaRole;

around apply => sub {
    my ( $orig, $self, $role_a, $role_b ) = @_;
    $self->$orig( $role_a, $role_b );

    ## no critic (ProhibitCallsToUnexportedSubs);

    $role_b = Moose::Util::MetaRole::apply_metaroles(
        for            => $role_b,
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

    $role_b->add_modifiers_from_role($role_a);
    return $role_b;
};

no Moose::Role;
1; # Magic true value required at end of module
__END__


=head1 SYNOPSIS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 DESCRIPTION

Apply this role to L<Moose::meta::Role::Application::ToRole|Moose::Meta::Role::Application::ToRole>.

=head1 DIAGNOSTICS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 DEPENDENCIES

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 INCOMPATIBILITIES

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 BUGS AND LIMITATIONS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

