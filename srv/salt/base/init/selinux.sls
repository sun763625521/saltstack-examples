close-selinux:
  file.managed:
    - name: /etc/selinux/config
    - source: salti://init/files/selinux_config
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: setenforce 0 || echo ok 
    - onlyif: getsebool
