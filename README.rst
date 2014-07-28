========
jmxtrans
========

Formula to set up and configure a node-local `jmxtrans <https://github.com/jmxtrans/jmxtrans>`_ service. Depends on a JDK/JRE
already installed, with the pillar ``java_home`` pointing to JAVA_HOME.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``jmxtrans``
-------

Downloads the jmxtrans tarball, installs the package, then configures and starts the service.

**NOTE**: the jmxtrans tarball *has to be* the one built with the *mvn package* command in the jmxtrans project.
This formula does not include any json configuration for actual metrics - you can just add whatever you need
to /etc/jmxtrans/json from where the jmxtrans service will pick it up on reload.

