# sh-sync-backup
Shell script that syncronizes backups from primary (local) backup storage to secondary (FTP) storage.

# Requirements
lftp package installed, for Debian: apt install lftp

# How to use
1. Edit resources.lst:
  - use correct path to your backups
  - use shell file masks to choose particular backups instead of all of them
  - provide depth in days to choose for how many last days backups would be synconized
 
 2. Edit config
 3. To run:
 sudo ./0_chmod.sh
 ./1_populate.sh
 ./2_sync.sh
 
 # Project status
 Deprecated since not needed in modern world
