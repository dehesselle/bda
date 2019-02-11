# Linux: block device attached
## motivation
I wanted to make something happen as soon as I plug in a certain USB stick or external harddrive. It should not matter how (many) storage devices are connected. And it should not all be hardwired to the one specific use case I'm doing this for, it should be extensible in a safe way without having to make changes to the main (mostly static) script/configuration/whatever. So, in more technical terms:

- create a system-level "autostart" mechanism for block devices
- do not rely on device names (e.g. `/dev/sdd`)
- generalize as much as possible, move specifics to dedicated files

I don't have to reinvent the wheel here, this has all been done before. It's just a matter of plugging the parts together in a way that I like. Those parts are udev, systemd and shellscripting.

### use case: snapshot on plug-in
I have an external USB harddrive, formatted with btrfs. Each time I plug it in, I want Linux to automatically create a new snapshot for a certain subvolume.

## solution
```
root
  ┣━━━etc
  ┃   ┣━━━blkdev-attached.d
  ┃   ┃   ┗━━━12345678-1234-1234-1234-1234567890ab
  ┃   ┣━━━systemd
  ┃   ┃   ┗━━━system 
  ┃   ┃       ┗━━━blkdev-attached@.service
  ┃   ┗━━━udev
  ┃       ┗━━━rules.d
  ┃           ┗━━━99-blkdev-attached.rules
  ┃
  ...
```

1. The rule in `99-blkdev-attached.rules` instructs udev to listen to "block device added" events. Whenever such an event is triggered, udev calls for...
2. ... a systemd service named `blkdev-attached@.service`, instantiating it with all the `ID_FS_UUID`s (mountable via `/dev/disk/by-uuid`) of said block device. Then the service oneshots...
3. ... a bash shell that runs some script code, checking the configuration folder `/etc/blkdev-attached.d` for a file named like the service's instance. If such a file is found, it gets sourced.
4. A script named "UUID" (like "1234...", see example above) contains all the commands that are supposed to run when said device attaches to the system.

Simply put: if you want to run some commands when you plug in a certain USB harddrive,
- determine the UUID of the partition/filesystem you're interested in (via `blkid`),
- put the commands into a file named like that UUID and
- place that file into the folder  `/etc/blkdev-attached.d`.

## installation
Place the systemd service and the udev rule into the directories as shown above. Create the configuration directory where you are going to place your UUID-named files into. Now you can either reboot or use 
```
systemctl daemon-reload
udevadm control --reload-rules
```
to activate the changes. 

Finally, create a UUID-named file and put the commands you want to run in it. My use case (create btrfs snapshot of a subvolume named `subvol1`) is included in `12345678-1234-1234-1234-1234567890ab`.

## credits
Everything here was built using systemd's documentation and inspired by other people's threads and postings in regards to udev and events.

## License
[MIT](LICENSE)
