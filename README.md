# Pi4 Home automation server

Basic home automation server with HomeAssistant, zegbee, etc.  

## Device naming convenctions

HA style device naming conventions

```
<domain>.<room>_<position>

# for ex:
light.livingroom_base
light.bedroom_sw_base
switch.bedroom_sw_door
```

## Backup / restore policy

Data to backup and Recovery Point Objective:  
- HA config, RPO 24h
- nodered config, RPO 24h
- zigbee2mqtt config, RPO 24h

Everyday full backup, history depth 1 week  
Based on 3-2-1 rule.  
Algorithm:  
- stop container
- mount /data 
- make archive to local drive
- make archive to remote drive

~/.bash_profile
```sh
export SERVER_BACKUP_DIR=/home/pi/backup
```

/var/spool/cron/crontabs/${USER}
```
 10 2  *   *   *     . $HOME/.profile; $HOME/iot-server/backup/backup.sh iot-server_zigbee_1 /app/data
 12 2  *   *   *     . $HOME/.profile; $HOME/iot-server/backup/backup.sh iot-server_nodered_1 /data
 14 2  *   *   *     . $HOME/.profile; $HOME/iot-server/backup/backup.sh iot-server_home-assistant_1 /config
 16 2  *   *   *     . $HOME/.profile; $HOME/iot-server/backup/backup.sh iot-server_wiki_1 /wiki
 18 2  *   *   *     . $HOME/.profile; $HOME/iot-server/backup/backup.sh iot-server_motioneye_1 /etc/motion /var/lib/motioneye
```

## Actions

```
docker run --volumes-from $NAME -it --rm alpine
```
