#!/bin/bash

# Copy priv_validator_state.json to the .oraid directory:
# Define file paths
echo "Copy the priv_validator_state.json to the .oraid directory..."
JSON_FILE="$HOME/.oraid/data/priv_validator_state.json"
ORAID_DIR="$HOME/.oraid/"

# Copy the priv_validator_state.json file to the .oraid directory
cp "$JSON_FILE" "$ORAID_DIR"

echo "File moved successfully to .oraid."

# Function to download the latest snapshot
download_latest_snapshot() {
    echo "Downloading the latest snapshot..."
    # Download the latest snapshot from BlockVal
    curl -L https://snap.blockval.io/oraichain/oraichain_latest.tar.lz4 -o "$HOME/oraichain_latest.tar.lz4"
}

# Function to download a specific snapshot
download_specific_snapshot() {
    echo "Visit https://snapshots.nysa.network/Oraichain/#Oraichain/"
    echo "Please enter the snapshot number:"
    read snapshot_number
    # Replace "xxxx" in the URL with the provided snapshot number
    url="https://snapshots.nysa.network/Oraichain/Oraichain_${snapshot_number}.tar.lz4"
    curl -L "$url" -o "$HOME/Oraichain_${snapshot_number}.tar.lz4"
}

# Ask user for download option with timeout
echo "Choose download option:"
echo "1. Download the BLOCKVAL latest snapshot"
echo "2. Download a NYSA-NETWORK snapshot - Please provide the latest snapshot number"
echo "Waiting for input... (Timeout in 2 minutes)"

if read -t 60 option; then
    # Perform the selected action
    case $option in
        1)
            download_latest_snapshot
            ;;
        2)
            download_specific_snapshot
            ;;
        *)
            echo "Invalid option. Downloading the latest snapshot by default."
            download_latest_snapshot
            ;;
    esac
else
    echo "No input received. Downloading the latest snapshot automatically."
    download_latest_snapshot
fi

# Wait until the snapshot is downloaded
while [ ! -f "$HOME/oraichain_latest.tar.lz4" ] && [ ! -f "$HOME/Oraichain_${snapshot_number}.tar.lz4" ]; do
    sleep 1
done

echo "Snapshot downloaded successfully."

# Stop the service
echo "Stopping the service..."
sudo systemctl stop oraid

# Remove the folders
echo "Removing old Data and Wasm folders..."
rm -rf $HOME/.oraid/data $HOME/.oraid/wasm

# Unzip the folders
echo "Unzipping the new Snapshot Folders..."
for file in $HOME/*.tar.lz4; do
	tar -I lz4 -xf "$file" -C $HOME/.oraid
	rm "$file"
done

# Wait until all folders are unzipped
while [ -n "$(find $HOME -maxdepth 1 -name '*.tar.lz4')" ]; do
	sleep 1
done
echo "New Snapshot Folders unzipped successfully."

# Remove new priv_validator_state.json and add the old one
# Define file paths
echo "Removing the new priv_validato_state.json and add the old one..."
OLD_FILE="$HOME/.oraid/priv_validator_state.json"
NEW_DIR="$HOME/.oraid/data/"
NEW_FILE="$NEW_DIR/priv_validator_state.json"
STATE_FILE="$HOME/.oraid/data/priv_validator_state.json"

# Remove the existing priv_validator_state.json file in data directory if it exists
if [ -f "$STATE_FILE" ]; then
	rm "$STATE_FILE"
	echo "Existing priv_validator_state.json file removed from data directory."
fi

# Copy the priv_validator_state.json file to the data directory
cp "$OLD_FILE" "$NEW_DIR"

echo "File moved successfully to $NEW_DIR."

# Start the service
echo "Starting the service..."
sudo systemctl start oraid

# Delete remaining tar.lz4 files
echo "Deleting remaining tar.lz4 files..."
rm -f $HOME/*.tar.lz4

echo "Script execution completed”
