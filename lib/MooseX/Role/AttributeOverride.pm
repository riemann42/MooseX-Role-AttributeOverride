package MooseX::Role::AttributeOverride;
# ABSTRACT: Allow roles to modify attributes
use 5.008;
use utf8;
use Moose::Role 1.9900;
use Moose::Exporter;

use MooseX::Role::AttributeOverride::Meta::Trait::Role;
use MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToClass;
use MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToRole;
use MooseX::Role::AttributeOverride::Meta::Trait::Role::Composite;


BEGIN {

    sub has_plus {
        my ($meta, $name, %options) = @_;
        if ($name =~ /\A \+/xms) {
            Moose->throw_error('Do not use a plus prefix with the has_plus sugar');
        }
        if ($meta->can('add_attribute_modifier')) {
            $meta->add_attribute_modifier([ $name => \%options ]);
        }
        else {
            require Moose;
            Moose->throw_error('Attempt to call has_plus on an invalid object');
        }
        return;
    }

    Moose::Exporter->setup_import_methods(
    with_meta => ['has_plus'],
    role_metaroles => {
            role =>
                ['MooseX::Role::AttributeOverride::Meta::Trait::Role'],
            application_to_class =>
                ['MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToClass'],
            application_to_role =>
                ['MooseX::Role::AttributeOverride::Meta::Trait::Role::ApplicationToRole'],
        },
        also => 'Moose::Role',
    );
}



1; # Magic true value required at end of module
__END__

=head1 SYNOPSIS

    package MyApp::Role;
    use Moose::Role;
    use MooseX::Role::AttributeOverride;

    has_plus 'fun' => (
        default => 'yep',
    );


    package MyApp;
    use Moose 1.9900;

    has 'fun' => (
        is => 'rw',
        isa => 'Str'
    );

    with qw(MyApp::Role);

    package main;
    use feature 'say';

    say "Are you having fun? " . $test->fun;

    # prints 'Are you having fun? yep'
  
=head1 DESCRIPTION

Moose doesn't allow roles to override attributes using the has '+attr' method.
There are several good reasons for that. Basically, "that's not what a role
is for."  A role is a set of requirements with defaults. A class should
always be able to override a role.

But sometimes you want a role to B<add> features to a class. This is why Moose
has method modifiers. This extension adds attribute modifiers.

=head1 INTERFACE 

=over

=item has_plus

This has exactly the same syntax as the Moose L<has|Moose/has> command, except
you should not use a plus to indicate you are overriding an attribute. 

=item has_plus options

=over

=item override_ignore_missing

Setting this to a true value will allow your role to have modifications to attributes 
that may not exist in the class it is applied to. The default is to die in these
cases.

For example:

    package MyApp::Role;
    use Moose::Role;
    use MooseX::Role::AttributeOverride;

    has_plus 'fun' => (
        default => 'yep',
        override_ignore_missing => 1,
    );

    package MyApp;
    use Moose;

    with qw(MyApp::Role);
    # I'm not dead yet.

The above would not die, even though the MyApp package has no attribute named
'fun.'

=back

=back

=head1 DIAGNOSTICS

=over

=item Can't find attribute $attr required by $role

You will see this error if your role has an attribute modification for an
attribute that is not in the class. You can squash this by setting the
'override_ignore_missing' option in your 'has_plus' command.

=item Attempt to call has_plus on an invalid object

You really should never see this. Please file a bug report if you do. A test
case would be nice as well.

=item Illegal inherited options 

Moose will throw this error if you try to change an accessor option. See 
L<the Moose manual|Moose::Manual::Attributes/"ATTRIBUTE INHERITANCE"> for more
details.

=item Do not use a plus prefix with the has_plus sugar

There is no need for a plus sign on your attribute:

    # Good
    has 'children', trait => ['good']

    # Bad. Will die.
    has '+children', trait => ['naughty']

=back

=head1 DEPENDENCIES

Moose 1.9900 or newer. Older versions may be supported in a future version of
this module.

=head1 INCOMPATIBILITIES

I am sure that there are some MooseX modules that will not work with this.
Please let me know, and I will at least document them.

=head1 BUGS AND LIMITATIONS

This is not the intended use of roles. As a result, take into account the
following:

=over

=item *

Order matters! If two roles modify the same attribute in the same way,
the second one applied will be the one that is used. This behavior, however,
relies on Moose keeping track of order, which it generally does a good job of,
but no guarantees.

=item *

Currently, the value of the attribute is clobbered when the role is applied.
This may change in the future.

=item *

This works the same as '+has'. This means that you can't override accessor
methods. This is a very sensible Moose limitation.

=back

I am relatively new to Moose. I had an itch, and wrote this Module to scratch
it. Please let me know how to make this module better.

For bugs, test cases are great! 

=head1 SEE ALSO
Moose
Moose::Manual::Attributes

=for stopwords
MooseX MyApp

