# Orai Server Disk Checker

The primary goal in developing this script is to prevent server downtime due to disk space reaching capacity, especially with the increased volume of blockchain data comparisons against historical data.

This script operates on the principle of Zero Touch Provisioning (ZTP), automating the monitoring and management of disk space. It conducts checks every 6 hours, triggering execution when disk usage surpasses 80%.

**System Requirements**

1) Operating System: Ubuntu

2) Sudo Permissions with No Password Prompt:
To disable the password prompt for sudo privileges, follow these steps:

Open the sudoers file using the command: 
```
sudo visudo

Add or replace the following line to the file:

#Allow members of group sudo to execute any command#

%sudo   ALL=(ALL:ALL) NOPASSWD:ALL

Save and exit the file. "Ctrl + x -> Y and Enter"
```
3) Systemd Service Setup and Enablement:
Ensure that the systemd service is set up and enabled for proper functionality.


**Here's a breakdown of the script's functionality:**

1. **Backup:** Copies the existing `priv_validator_state.json` from the `data` folder and moves it to `.oraid`.
2. **Snapshot Update:** Downloads the latest snapshot.
3. **Service Shutdown:** Halts the `oraid` service.
4. **Preparation:** Removes old `data` and `wasm` folders before unzipping the new snapshot.
5. **Snapshot Deployment:** Unzips and relocates the new `data` and `wasm` folders to `.oraid`.
6. **Restoration:** Deletes the new `priv_validator_state.json` and restores the original file to the `data` folder.
7. **Service Restart:** Initiates the `oraid` service.
8. **Cleanup:** Removes the downloaded snapshot tar file.

Installation Instructions:

1. **Download the Files:** Retrieve the necessary files onto your server.
   ```
   cd $HOME
   sudo git clone https://github.com/Crypt0Genesis/diskchecker_HOME-oraid.git
   ```

3. **Permissions:** Set executable permissions for the `disk-space-script.sh` file using:
   ```
   sudo chmod +x disk-space-script.sh
   ```

4. **Disk Space Monitoring:** Make the `check_disk_script.sh` file executable:
   ```
   sudo chmod +x check_disk_script.sh
   ```

5. **Crontab Configuration:** Access the crontab scheduler with:
   ```
   crontab -e
   ```
   Then, add the following lines to schedule disk space checks every 6 hours:
   ```
   # Check disk space every 6 hours
   0 */6 * * * /$HOME/diskchecker_HOME-oraid/check_disk_script.sh
   ```

**Setup Example**

```
cryptogenesis@Orai-Node:~$ cd $HOME
cryptogenesis@Orai-Node:~$ sudo git clone https://github.com/Crypt0Genesis/diskchecker_HOME-oraid.git
Cloning into 'diskchecker_orai-orai-oraid'...
remote: Enumerating objects: 86, done.
remote: Counting objects: 100% (86/86), done.
remote: Compressing objects: 100% (85/85), done.
remote: Total 86 (delta 49), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (86/86), 41.19 KiB | 3.17 MiB/s, done.
Resolving deltas: 100% (49/49), done.

cryptogenesis@Orai-Node:~$ ls
diskchecker_HOME-oraid  go  orai 

cryptogenesis@Orai-Node:~$ cd diskchecker_HOME-oraid

cryptogenesis@Orai-Node:~/diskchecker_HOME-oraid$ ls
LICENSE  README.md  check_disk_script.sh  disk-space-script.sh

cryptogenesis@Orai-Node:~/diskchecker_HOME-oraid$ sudo chmod +x check_disk_script.sh

cryptogenesis@Orai-Node:~/diskchecker_HOME-oraid$ sudo chmod +x disk-space-script.sh

cryptogenesis@Orai-Node:~/diskchecker_HOME-oraid$ crontab -e
no crontab for orainode - using an empty one

Select an editor.  To change later, run 'select-editor'.
  1. /bin/nano        <---- easiest
  2. /usr/bin/vim.basic

Choose 1-2 [1]: 1

#m h  dom mon dow   command
   # Check disk space every 6 hours
   0 */6 * * * /$HOME/diskchecker_HOME-oraid/check_disk_script.sh

Now Run the Script Manually:
orainode@Orai-Node:~/diskchecker_HOME-oraid$ ./check_disk_script.sh
Disk space is below 80%. No action required.
```

**If Disk Space reach at 80% or Above**
```
cryptogenesis@Orai-Node:~/diskchecker_HOME-oraid$ ./check_disk_script.sh
Disk space is at 80%. Running script...
Copy the priv_validator_state.json to the .oraid directory...
File moved successfully to .oraid.

Snapshot Download
Choose download option:
1. Download the BLOCKVAL latest snapshot
2. Download a NYSA-NETWORK snapshot 
Please enter the option 1 or 2
Waiting for input... (Timeout in 1 minute)
2
(Visit https://snapshots.nysa.network/Oraichain/#Oraichain/)
Please enter the latest snapshot number:
20431522

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 9073M  100 9073M    0     0  25.2M      0  0:05:58  0:05:58 --:--:-- 39.3M
Snapshot downloaded successfully.

Stopping the oraid service...
Removing old Data and Wasm folders...
Removed old Data and Wasm folders...
Unzipping the new Snapshot Folders...
New Snapshot Folders unzipped successfully.
Removing the new priv_validator_state.json and add the old one...
Existing priv_validator_state.json file removed from data directory.
File moved successfully to /home/cryptogenesis/.oraid/data/.
Starting the oraid service...
Deleting remaining tar.lz4 files...
Script execution completed....
Script Developed By Crypto-Genesis.... Happy Validating :)
```


**Additional Information:**

We've implemented options for downloading snapshots, allowing users to select the desired image. A special acknowledgment to NysaNetwork and Blockval for extending their snapshot services to the Orai community.

Efforts are underway to swiftly deploy our own Orai validator dashboard, Sentry node, RPC, and snapshots. Once available, we'll promptly share them with our Orai community. In the interim, we'll utilize the snapshots provided by NysaNetworks and Blockval.

1. BlockVal Usage:
   By default, Blockval's snapshot feature selects the latest available snapshot. However, please note that sometimes the snapshot size can range from 40-50GB.
   The script will automatically opt for Blockval's image, as the link directs to the latest snapshot. 

2. NysaNetwork Usage (Recommended):
   The snapshot size from NysaNetwork is approximately 9GB. However, the image name varies each time.
 

If you opt to use the script manually, you'll have the choice to select your preferred snapshot image. Upon manual execution, the script will present you with Option 1 and Option 2. If no option is selected, the script will wait for 1 minute before proceeding to download the default snapshot from BlockVal.

If you run the script manually and choose Option 2 to download the Nysa snapshot, the script will prompt you to enter the latest image reference. You can obtain this reference from the Nysa Network website.


**NOTE**
```
We've thoroughly tested the script and it operates flawlessly. However, I welcome your feedback and suggestions for further enhancements. Feel free to reach out with any concerns or improvement ideas. Thanks!

Crypto-Genesis Validator:
https://t.me/crypt0genesis
https://scan.orai.io/validators/oraivaloper1r8zzyp7ffnuzlqv5hp75yhqrxf4g9fad532p7h
