# Orai Disk Checker

The primary goal in developing this script is to prevent server downtime due to disk space reaching capacity, especially with the increased volume of blockchain data comparisons against historical data.

This script operates on the principle of Zero Touch Provisioning (ZTP), automating the monitoring and management of disk space. It conducts checks every 6 hours, triggering execution when disk usage surpasses 80%.

Here's a breakdown of the script's functionality:

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
   sudo git clone https://github.com/Crypt0Genesis/diskcecker_HOME-oraid.git
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
   0 */6 * * * /$HOME/check_disk_script.sh
   ```

I've thoroughly tested the script and it operates flawlessly. However, I welcome your feedback and suggestions for further enhancements. Feel free to reach out with any concerns or improvement ideas. Thanks!
