package MooseX::Role::AttributeOverride::Meta::Trait::Role;
use Moose::Role;

has '_attribute_modifiers' =>
    (   is => 'rw',
        isa => 'ArrayRef',
        default => sub {[]},
        traits => ['Array'],
        handles => {
            _add_attribute_modifier => 'push',
        }
    );

sub _apply_modifiers { 
    my ($role,$class) = @_;
    for ( @{ $role->_attribute_modifiers } ) {
        my ( $name, $opts ) = @{$_};
        my $attrs = ( ref($name) eq 'ARRAY' ) ? $name : [ ($name) ];
        for my $attr ( @{$attrs} ) {
            my $attr_obj = $class->find_attribute_by_name($attr);
            if ($attr_obj) {
                $class->add_attribute($attr_obj->clone_and_inherit_options(%{$opts}));
            }
            else {
                warn "Can't find attribute: $attr required by ".  $role->name;
            }
        }
    }
    return $class;
}

sub _add_additional_role {
    my ($role1,$role2) = @_; 
    $role1->_add_attribute_modifier(@{$role2->_attribute_modifiers});
    return $role1;
}

sub composition_class_roles { 'MooseX::Role::AttributeOverride::Meta::Trait::Role::Composite' }

no Moose::Role;
1;
