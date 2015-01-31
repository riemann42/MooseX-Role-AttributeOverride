#INSTALLATION

This distribution is managed using
[Dist::Zilla](https://metacpan.org/release/Dist-Zilla). If all you
want to do is to install the latest stable distribution of
MooseX::Role::AttributeOverride, your best bet is to install it from
CPAN using your usual CPAN client:

    $ cpanm MooseX::Role::AttributeOverride # cpan or cpanp also work

If you want to install this GitHub version of the distribution you
need to have an up-to-date installation of Dist::Zilla. This is more
complicated than installing direct from CPAN.

Dist::Zilla needs to be be installed from CPAN first (**warning**
it's a large distribution with many dependencies - as of this
writing, 32MB in 165 distributions for the base installation):

    $ cpanm Dist::Zilla

If you haven't done so already, you'll need to download
MooseX::Role::AttributeOverride from GitHub:

    $ git clone https://github.com/riemann42/MooseX-Role-AttributeOverride.git

Then, from the directory of your newly cloned
MooseX::Role::AttributeOverride, you need to use Dist::Zilla to
install all the plug-ins the distribution author used (again, this can
be sizeable - on my system another 14MB in 109 distributions were
installed):

    $ dzil authordeps | cpanm

Finally, you can use Dist::Zilla to test and install
MooseX::Role::AttributeOverride:

    $ dzil test
    $ dzil install
