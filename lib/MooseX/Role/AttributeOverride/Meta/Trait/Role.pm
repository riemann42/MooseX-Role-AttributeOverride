package MooseX::Role::AttributeOverride::Meta::Trait::Role;
use strict;
use warnings;
use version; our $VERSION = qv('0.0.3');
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

=head1 NAME

MooseX::Role::AttributeOverride::Meta::Trait::Role - Support Role for
L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 VERSION

This document describes MooseX::Role::AttributeOverride version 0.0.3


=head1 SYNOPSIS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 DESCRIPTION

This module is part of L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 INTERFACE 

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 INTERNAL METHODS

=over

=item composition_class_roles

=item add_modifiers_from_role

=item apply_modifiers_to_class

=item apply_modifier_to_attribute

=item attribute_modifiers

=item add_attribute_modifier

=back

=head1 DIAGNOSTICS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 DEPENDENCIES

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 INCOMPATIBILITIES

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 BUGS AND LIMITATIONS

See L<MooseX::Role::AttributeOverride|MooseX::Role::AttributeOverride>

=head1 AUTHOR

Edward Allen  C<< <ealleniii_at_cpan_dot_org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2011, Edward Allen C<< <ealleniii_at_cpan_dot_org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic|perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
