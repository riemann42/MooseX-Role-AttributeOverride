package MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToRole;
use Moose::Role;

around apply => sub {
    my $orig = shift;
    my $self = shift;
    my ( $role1, $role2 ) = @_;
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
    $role2->_add_additional_role($role1);
};

no Moose::Role;

1;

__END__

=pod

=head1 NAME

MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToRole

=head1 VERSION

version 0.10

=head1 SEE ALSO

=over 4

=item *

L<MooseX::Role::AttributeOverride>

=back

=head1 AUTHORS

=over 4

=item *

Jesse Luehrs <doy at tozt dot net>

=item *

Chris Prather <chris@prather.org>

=item *

Justin Hunter <justin.d.hunter at gmail dot com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Jesse Luehrs.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

