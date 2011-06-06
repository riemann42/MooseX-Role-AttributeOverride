package MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToRole;
# ABSTRACT: Support Role for L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>
use 5.008;
use Moose::Role;

around apply => sub {
    my ( $orig, $self, $role1, $role2 ) = @_;
    $self->$orig( $role1, $role2 );
    $role2 = Moose::Util::MetaRole::apply_metaroles(
        for            => $role2,
        role_metaroles => {
            role =>
                ['MooseX::Role::AttributeOverride::Meta::Trait::Role'],
            application_to_class =>
                ['MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToClass'],
            application_to_role =>
                ['MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToRole'],
            },
    );
    $role2->add_modifiers_from_role($role1);
    return $role2;
};

no Moose::Role;
1; # Magic true value required at end of module
__END__


=head1 SYNOPSIS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 DESCRIPTION

Apply this role to L<Moose::Meta::Role::Application::ToRole>.

=head1 DIAGNOSTICS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 DEPENDENCIES

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 INCOMPATIBILITIES

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 BUGS AND LIMITATIONS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

