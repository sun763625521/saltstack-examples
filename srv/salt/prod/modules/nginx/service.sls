include:
  - modules.nginx.install

nginx-init:
  file.managed:
    - name: /usr/lib/systemd/system/nginx.service
    - source: salt://modules/nginx/files/nginx-service
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: systemctl daemon-reload
    - require:
      - file: nginx-init

/usr/local/nginx/conf/nginx.conf:
  file.managed:
    - source: salt://modules/nginx/files/nginx.conf
    - user: www
    - group: www
    - mode: 644

nginx-service:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
      - cmd: nginx-init
    - watch:
      - file: /usr/local/nginx/conf/nginx.conf
      - file: nginx-online


nginx-online:
  file.directory:
     - name: /usr/local/nginx/conf/vhost_online

nginx-offline:
  file.directory:
     - name: /usr/local/nginx/conf/vhost_offline
    












 
