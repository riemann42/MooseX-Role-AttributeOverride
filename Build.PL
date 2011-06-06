use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'MooseX::Role::AttributeOverride',
    license             => 'perl',
    dist_author         => 'Edward Allen <ealleniii_at_cpan_dot_org>',
    dist_version_from   => 'lib/MooseX/Role/AttributeOverride.pm',
    requires => {
        'version'    => 0.77,
        'Moose'      => 1.9900,
    },
    build_requires => {
        'Test::More' => 0,
        'TAP::Harness' => 0,
    },
    configure_requires => { 'Module::Build' => 0.38 },
    add_to_cleanup      => [ 'MooseX-Role-AttributeOverride-*' ],
    use_tap_harness => 1,
    create_license => 1,
    #release_status => 'unstable',
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
