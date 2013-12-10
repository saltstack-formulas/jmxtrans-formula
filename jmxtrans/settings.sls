{%- set uid = salt['pillar.get']('users:jmxtrans:uid', '6095') %}

{%- set pillar_version = salt['pillar.get']('jmxtrans:version', '2013.11.29') %}
{%- set version = salt['grains.get']('jmxtrans:version', pillar_version) %}
{%- set version_name = 'jmxtrans-' + version %}

{%- set pillar_source_url = salt['pillar.get']('jmxtrans:source_url','http://sroegner-install.s3.amazonaws.com/jmxtrans-' + version + '-sqrrl.tar.gz') %}
{%- set source_url = salt['pillar.get']('jmxtrans:source_url', pillar_source_url) %}
{%- set alt_home         = salt['pillar.get']('jmxtrans:prefix', '/usr/lib/jmxtrans') %}
{%- set real_home        = '/usr/lib/' + version_name %}
{%- set alt_config       = salt['pillar.get']('jmxtrans:config:directory', '/etc/jmxtrans/conf') %}
{%- set real_config      = alt_config + '-' + version %}
{%- set real_config_dist = alt_config + '.dist' %}
{%- set java_home = salt['pillar.get']('java_home', '/usr/lib/java') %}


{%- set jmxtrans = {} %}

{%- do jmxtrans.update( { 'uid'              : uid,
                          'java_home'        : java_home,
                          'version'          : version,
                          'version_name'     : version_name,
                          'source_url'       : source_url,
                          'alt_home'         : alt_home,
                          'real_home'        : real_home,
                          'alt_config'       : alt_config,
                          'real_config'      : real_config,
                          'real_config_dist' : real_config_dist
                      }) %}