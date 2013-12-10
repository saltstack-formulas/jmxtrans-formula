{%- from 'jmxtrans/settings.sls' import jmxtrans with context %}

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
      - cmd.run: unpack-jmxtrans-dist

{{ jmxtrans['real_home'] }}:
  file.directory:
    - user: root
    - group: root
    - recurse:
      - user
      - group
    - require:
      - cmd.run: unpack-jmxtrans-dist

{% set real_config_src = jmxtrans['real_home'] + '/conf' %}

/etc/jmxtrans:
  file.directory:
    - owner: root
    - group: root
    - mode: 755

/etc/jmxtrans/json:
  file.directory:
    - owner: root
    - group: root
    - mode: 755

move-jmxtrans-dist-conf:
  file.directory:
    - name: {{ jmxtrans['real_config'] }}
    - user: root
    - group: root
  cmd.run:
    - name: mv  {{ real_config_src }} {{ jmxtrans['real_config_dist'] }}
    - unless: test -L {{ real_config_src }}
    - onlyif: test -d {{ real_config_src }}
    - require:
      - file.directory: {{ jmxtrans['real_home'] }}
      - file.directory: /etc/jmxtrans

{{ real_config_src }}:
  file.symlink:
    - target: {{ jmxtrans['alt_config'] }}
    - require:
      - cmd: move-jmxtrans-dist-conf

jmxtrans-conf-link:
  alternatives.install:
    - link: {{ jmxtrans['alt_config'] }}
    - path: {{ jmxtrans['real_config'] }}
    - priority: 30
    - require:
      - file.directory: {{ jmxtrans['real_config'] }}

make-script-executable:
  cmd.wait:
    - name: chmod 755 {{ jmxtrans.alt_home }}/jmxtrans.sh
    - watch:
      - cmd: unpack-jmxtrans-dist

/etc/init.d/jmxtrans:
  file.managed:
    - source: salt://jmxtrans/files/jmxtrans
    - template: jinja
    - mode: 755
    - context:
      jmxtrans_prefix: {{ jmxtrans.alt_home }}
      jmxtrans_config: {{ jmxtrans.alt_config }}
      jmxtrans_user: jmxtrans

{%- if jmxtrans.graphite_host is defined %}
{{ jmxtrans.alt_config }}/jmxtrans-env.sh:
  file.managed:
    - source: salt://jmxtrans/files/jmxtrans-env.sh
    - template: jinja
    - mode: 755
    - context:
      java_home: {{ jmxtrans.java_home }}
      jmxtrans_prefix: {{ jmxtrans.alt_home }}
      jmxtrans_jsondir: /etc/jmxtrans/json
      jmxtrans_logdir: /var/log/jmxtrans
      graphite_host: {{ jmxtrans.graphite_host }}
      graphite_port: {{ jmxtrans.graphite_port }}

enable-jmxtrans-service:
  service:
    - name: jmxtrans
    - running
    - enable: True
    - reload: True
    - watch:
      - file: {{ jmxtrans.alt_config }}/jmxtrans-env.sh
{%- endif %}
