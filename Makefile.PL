use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'MooseX::Role::AttributeOverride',
    AUTHOR              => 'Edward Allen <ealleniii_at_cpan_dot_org>',
    VERSION_FROM        => 'lib/MooseX/Role/AttributeOverride.pm',
    ABSTRACT_FROM       => 'lib/MooseX/Role/AttributeOverride.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'MooseX-Role-AttributeOverride-*' },
);
