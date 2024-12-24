#!/bin/bash
chmod +x START_Mac.shsh ./START_Mac.sh

# Function to open a new Terminal window and execute a command
open_new_terminal() {
    local directory="$1"
    local command="$2"

    osascript <<END
tell application "Terminal"
    activate
    do script "cd \"$directory\" && $command"
end tell
END
}

# Start Backend
echo "Starting backend server..."
cd UNISAT_BACK || { echo "Directory UNISAT_BACK not found!"; exit 1; }

# Install backend dependencies if not already installed
if [ -d "node_modules" ]; then
    echo "Backend dependencies are already installed."
else
    echo "Installing backend dependencies..."
    npm install
fi

# Start backend server in a new Terminal window
open_new_terminal "$(pwd)" "npm start"

cd ..

# Start Frontend
echo "Starting frontend server..."
cd UNISAT_FRONT || { echo "Directory UNISAT_FRONT not found!"; exit 1; }

# Install frontend dependencies if not already installed
if [ -d "node_modules" ]; then
    echo "Frontend dependencies are already installed."
else
    echo "Installing frontend dependencies..."
    npm install
fi

# Start frontend server in a new Terminal window
open_new_terminal "$(pwd)" "npm start"

cd ..

echo "Project successfully started. Opening browser..."

# Wait a few seconds to allow servers to start
sleep 5

# Open the browser with your site
open http://localhost:4200

echo "Done!"
