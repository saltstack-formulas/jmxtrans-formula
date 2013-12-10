===
jmxtrans
===

Formula to set up and configure a node-local jmxtrans server.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/topics/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``jmxtrans``
-------

Downloads the jmxtrans tarball, installs the package, then configures and starts the service.
This formula does not include any json configuration for actual metrics - you can just add whatever you need
to /etc/jmxtrans/json from where the jmxtrans server will pick it up.

