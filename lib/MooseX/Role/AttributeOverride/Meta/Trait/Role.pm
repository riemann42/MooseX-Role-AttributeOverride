package MooseX::Role::AttributeOverride::Meta::Trait::Role;
# ABSTRACT: Support Role for L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>
use 5.008;
use utf8;

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
    ## no critic (ProhibitAccessOfPrivateData);
    if ($attr_obj) {
        if ( exists $opts->{override_ignore_missing} ) {
            delete $opts->{override_ignore_missing};
        }
        $class->add_attribute(
            $role->clone_attr_and_inherit_options( $attr_obj, %{$opts} ) );
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
    ## use critic;
    return $attr_obj;
}


# Based on clone_and_inherit_options from Moose::Meta::Attribute.

sub clone_attr_and_inherit_options {
    my ($role, $attr, %options) = @_;

    my @illegal_options = $attr->can('illegal_options_for_inheritance')
        ? $attr->illegal_options_for_inheritance
        : ();

    my @found_illegal_options = grep { exists $options{$_} && exists $attr->{$_} ? $_ : undef } @illegal_options;
    (scalar @found_illegal_options == 0)
        || $attr->throw_error("Illegal inherited options => (" . (join ', ' => @found_illegal_options) . ")", data => \%options);

    if ($attr->can('interpolate_class')) {
        ( $options{metaclass}, my @traits ) = $attr->interpolate_class(\%options);

        my %seen;
        my @all_traits = grep { $seen{$_}++ } @{ $attr->applied_traits || [] }, @traits;
        $options{traits} = \@all_traits if @all_traits;
    }

    if ($options{coerce} && (! exists $options{isa})) {
        $options{isa} = $attr->type_constraint;
    }

    $options{metaclass}->_process_options( $attr->name, \%options )
        if $attr->can('_process_options');
    
    $attr->clone(%options);
}

sub add_modifiers_from_role {
    my ( $role_a, $role_b ) = @_;
    $role_a->add_attribute_modifier( @{ $role_b->attribute_modifiers } );
    return $role_a;
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

Apply this role to L<Moose::Meta::Role|Moose::Meta::Role>.

=head1 DIAGNOSTICS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 DEPENDENCIES

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 INCOMPATIBILITIES

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 BUGS AND LIMITATIONS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

