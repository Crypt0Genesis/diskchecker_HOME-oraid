#!/bin/bash

# Copy priv_validator_state.json to the .oraid directory:
# Define file paths
echo "Copy the priv_validator_state.json to the .oraid directory..."
JSON_FILE="$HOME/.oraid/data/priv_validator_state.json"
ORAID_DIR="$HOME/.oraid/"

# Copy the priv_validator_state.json file to the .oraid directory
cp "$JSON_FILE" "$ORAID_DIR"

echo "File moved successfully to .oraid."


# Download the Snapshot
echo "Downloading the Snapshot..."
curl -L https://snap.blockval.io/oraichain/oraichain_latest.tar.lz4 -o $HOME/oraichain_latest.tar.lz4

# Wait until the folders are downloaded
while [ ! -f $HOME/oraichain_latest.tar.lz4 ]; do
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
