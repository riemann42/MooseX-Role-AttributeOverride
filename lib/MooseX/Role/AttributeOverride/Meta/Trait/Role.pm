package MooseX::Role::AttributeOverride::Meta::Trait::Role;
# ABSTRACT: Support Role for L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

use 5.008;

use strict;
use warnings;
use Moose::Role;

has 'attribute_modifiers' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { [] },
    traits  => ['Array'],
    handles => { add_attribute_modifier => 'push', }
);

sub apply_modifiers_to_class {
    my ( $role, $class ) = @_;
    for ( @{ $role->attribute_modifiers } ) {
        my ( $name, $opts ) = @{$_};
        my $attrs = ( ref($name) eq 'ARRAY' ) ? $name : [ ($name) ];
        for my $attr ( @{$attrs} ) {
            $role->apply_modifier_to_attribute( $class, $attr, $opts );
        }
    }
    return $class;
}

sub apply_modifier_to_attribute {
    my ( $role, $class, $attr, $opts ) = @_;
    my $attr_obj = $class->find_attribute_by_name($attr);
    if ($attr_obj) {
        if ( exists $opts->{override_ignore_missing} ) {
            delete $opts->{override_ignore_missing};
        }
        $class->add_attribute(
            $attr_obj->clone_and_inherit_options( %{$opts} ) );
    }
    else {
        my $error = qq{Can't find attribute $attr required by } . $role->name;
        require Moose;
        if (   ( !exists $opts->{override_ignore_missing} )
            || ( !       $opts->{override_ignore_missing} ) ) {
            Moose->throw_error($error);
        }
        return;
    }
    return $attr_obj;
}

sub add_modifiers_from_role {
    my ( $role1, $role2 ) = @_;
    $role1->add_attribute_modifier( @{ $role2->attribute_modifiers } );
    return $role1;
}

sub composition_class_roles {
    return ('MooseX::Role::AttributeOverride::Meta::Trait::Role::Composite');
}

no Moose::Role;
1; # Magic true value required at end of module
__END__

=head1 SYNOPSIS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=method composition_class_roles

=method add_modifiers_from_role

=method apply_modifiers_to_class

=method apply_modifier_to_attribute

=method attribute_modifiers

=method add_attribute_modifier

=head1 DESCRIPTION

Apply this role to L<Moose::Meta::Role>.

=head1 DIAGNOSTICS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 DEPENDENCIES

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 INCOMPATIBILITIES

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 BUGS AND LIMITATIONS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

