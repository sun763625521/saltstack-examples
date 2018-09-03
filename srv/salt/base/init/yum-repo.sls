/etc/yum.repos.d/epel.repo:
  file.managed:
    - source: salt://init/files/epel.repo.templete
    - user: root
    - group: root
    - mode: 644
