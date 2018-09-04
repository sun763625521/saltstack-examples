include:
  - modules.redis.install

slave-config:
  cmd.run:
    - name: redis-cli -h 192.168.10.142 slaveof 192.168.10.49 6379
    - unless: redis-cli -h 192.168.10.142 info | grep role:slave
    - require:
      - service: redis-service
