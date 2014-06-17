{%- if 'monitor' in salt['grains.get']('roles',[]) %}

{%- from 'jmxtrans/settings.sls' import jmxtrans with context %}
{%- from 'graphite/settings.sls' import graphite with context %}

jmxtrans:
  group.present:
    - gid: {{ jmxtrans.uid }}
  user.present:
    - gid: {{ jmxtrans.uid }}
    - uid: {{ jmxtrans.uid }}
    - shell: /bin/bash
  file.directory:
    - user: jmxtrans
    - group: jmxtrans
    - mode: 775
    - names:
      - /var/log/jmxtrans
      - /var/run/jmxtrans
      - /var/lib/jmxtrans
    - require:
      - user: jmxtrans

unpack-jmxtrans-dist:
  cmd.run:
    - name: curl '{{ jmxtrans.source_url }}' | tar xz
    - cwd: /usr/lib
    - unless: test -d {{ jmxtrans['real_home'] }}/lib

jmxtrans-home-link:
  alternatives.install:
    - link: {{ jmxtrans['alt_home'] }}
    - path: {{ jmxtrans['real_home'] }}
    - priority: 30
    - require:
      - cmd: unpack-jmxtrans-dist

{{ jmxtrans['real_home'] }}:
  file.directory:
    - user: root
    - group: root
    - recurse:
      - user
      - group
    - require:
      - cmd: unpack-jmxtrans-dist

{% set real_config_src = jmxtrans['real_home'] + '/conf' %}

config-directories:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - names:
      - {{ jmxtrans.real_config }}
      - {{ jmxtrans.json_dir }}

{{ real_config_src }}:
  file.symlink:
    - target: {{ jmxtrans['alt_config'] }}

jmxtrans-conf-link:
  alternatives.install:
    - link: {{ jmxtrans['alt_config'] }}
    - path: {{ jmxtrans['real_config'] }}
    - priority: 30
    - require:
      - file: {{ jmxtrans['real_config'] }}

{{ jmxtrans.alt_home }}/bin/jmxtrans.sh:
  file.touch:
    - user: root
    - group: root
    - mode: 755

/etc/init.d/jmxtrans:
  file.managed:
    - source: salt://jmxtrans/files/jmxtrans
    - template: jinja
    - mode: 755
    - context:
      jmxtrans_prefix: {{ jmxtrans.alt_home }}
      jmxtrans_config: {{ jmxtrans.alt_config }}
      jmxtrans_user: jmxtrans

/etc/sysconfig/jmxtrans:
  file.managed:
    - source: salt://jmxtrans/files/jmxtrans.sysconfig
    - template: jinja
    - context:
      java_home: {{ jmxtrans.java_home }}
      jmxtrans_prefix: {{ jmxtrans.alt_home }}
      jmxtrans_jsondir: {{ jmxtrans.json_dir }}
      jmxtrans_logdir: /var/log/jmxtrans
      jmxtrans_loglevel: {{ jmxtrans.log_level }}
      graphite_host: {{ graphite.host }}
      graphite_port: {{ graphite.port }}
      source_host: {{ jmxtrans.source_host }}

enable-jmxtrans-service:
  service.running:
    - name: jmxtrans
    - enable: True

{%- endif %}
