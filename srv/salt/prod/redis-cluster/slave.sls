include:
  - modules.redis.install

slave-config:
  cmd.run:
    - name: redis-cli -h 192.168.10.142 slaveof 192.168.10.49 6379
    - unless: redis-clit -h 192.168.56.12 info | grep role:slave
    - require:
      - service: redis-service
