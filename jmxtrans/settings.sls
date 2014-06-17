{% set p  = salt['pillar.get']('jmxtrans', {}) %}
{% set pc = p.get('config', {}) %}
{% set g  = salt['grains.get']('jmxtrans', {}) %}
{% set gc = g.get('config', {}) %}

{%- set uid = salt['pillar.get']('users:jmxtrans:uid', '6095') %}

{%- set version = g.get('version', p.get('version', '1.0.1')) %}
{%- set version_name = 'jmxtrans-' + version %}

{%- set default_source_url = 'http://sroegner-install.s3.amazonaws.com/jmxtrans-' + version + '-dist.tar.gz' %}
{%- set source_url       = g.get('source_url', p.get('source_url', default_source_url)) %}
{%- set alt_home         = g.get('prefix', p.get('prefix', '/usr/lib/jmxtrans')) %}
{%- set real_home        = '/usr/lib/' + version_name %}
{%- set alt_config       = gc.get('directory', pc.get('directory','/etc/jmxtrans/conf')) %}
{%- set json_dir         = gc.get('json_directory', pc.get('json_directory','/etc/jmxtrans/json')) %}
{%- set log_level        = gc.get('log_level', pc.get('log_level','error')) %}
{%- set real_config      = alt_config + '-' + version %}
{%- set real_config_dist = alt_config + '.dist' %}
{%- set java_home        = salt['pillar.get']('java_home', '/usr/lib/java') %}
{%- set source_host      = salt['grains.get']('id', 'unknown-host').split('.') | first() %}

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
                          'real_config_dist' : real_config_dist,
                          'source_host'      : source_host,
                          'log_level'        : log_level,
                          'json_dir'         : json_dir,
                      }) %}
