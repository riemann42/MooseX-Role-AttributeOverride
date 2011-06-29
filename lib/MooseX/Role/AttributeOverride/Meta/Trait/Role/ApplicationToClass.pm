package MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToClass;
# ABSTRACT: Support Role for L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>
use 5.008;
use utf8;
use Moose::Role;

around apply => sub {
    my ($orig,$self, $role, $class ) = @_;

    $self->$orig( $role, $class );

    if ( $role->can('attribute_modifiers') ) {
        $role->apply_modifiers_to_class($class);
    }

};

no Moose::Role;
1; # Magic true value required at end of module
__END__

=head1 SYNOPSIS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 DESCRIPTION

Apply this role to L<Moose::Meta::Role::Application::ToClass|Moose::Meta::Role::Application::ToClass>.

=head1 DIAGNOSTICS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 DEPENDENCIES

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 INCOMPATIBILITIES

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 BUGS AND LIMITATIONS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

