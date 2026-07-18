#!/bin/bash

# Find script location
SCRIPT_DIR="$(dirname "$0")"

# Move to script location
cd "$SCRIPT_DIR" || exit

# Game Information
Game="StoryRpg"
Version="1.21"

# Game Directory
mkdir -p Game_Server_Manager
cd Game_Server_Manager || exit

# Create Log Files
touch logs/server.log
touch logs/player.log
touch logs/system.log

# Initialize Server Log
echo "INFO Setup Initialized" >> logs/server.log
echo "INFO Game Name: $Game" >> logs/server.log
echo "INFO Version: $Version" >> logs/server.log

# Initialize Player Log
echo "==================================" >> logs/player.log
echo "       StoryRpg Setup" >> logs/player.log
echo "         Version $Version" >> logs/player.log
echo "==================================" >> logs/player.log
echo 
echo "Preparing StoryRpg server setup..."
echo "Please answer the following questions."
echo 


# Customization
echo "==================="
echo "Customization Setup"
echo "==================="

PromptCustomization() {

    local Question="$1"
    local SelectedMessage="$2"
    local NoMessage="$3"
    local SaveVariable="$4"
    local Answer

    echo "$Question"
    read -r Answer

    Answer=${Answer,,}

    while [[ "$Answer" != "yes" && "$Answer" != "no" ]]
    do
        echo "Please enter 'yes' or 'no'."
        read -r Answer
        Answer=${Answer,,}
    done

    if [[ "$Answer" = "yes" ]]
    then
        echo "$SelectedMessage"
    else
        echo "$NoMessage"
    fi

    printf -v "$SaveVariable" "%s" "$Answer"
}

# Hats Selection
PromptCustomization \
"Would you like hats? yes/no" \
"Hats Enabled" \
"Hats Disabled" \
HatChoice

# Pets Selection
PromptCustomization \
"Would you like a pet? yes/no" \
"Pets Enabled" \
"Pets Disabled" \
PetChoice

# Glasses Selection
PromptCustomization \
"Would you like glasses? yes/no" \
"Glasses Enabled" \
"Glasses Disabled" \
GlassesChoice

# Difficulty
echo "Select difficulty (hard/normal):"
read -r Difficulty

Difficulty=${Difficulty,,}

while [[ "$Difficulty" != "hard" && "$Difficulty" != "normal" ]]
do
    echo "Please enter 'hard' or 'normal'."
    read -r Difficulty
    Difficulty=${Difficulty,,}
done

if [[ "$Difficulty" = "hard" ]]
then
    echo "Respawning: Disabled"
else
    echo "Respawning: Enabled"
fi


# World Name
while true
do
    echo "Enter your world name:"
    read -r WorldName

    WorldName=${WorldName,,}

    while [[ -z "$WorldName" ]]
    do
        echo "Please enter your world name."
        read -r WorldName
        WorldName=${WorldName,,}
    done

    echo 
    echo "World Name: $WorldName"
    echo "Is this correct? yes/no"
    read -r Confirm

    Confirm=${Confirm,,}

    while [[ "$Confirm" != "yes" && "$Confirm" != "no" ]]
    do
        echo "Please type yes or no."
        read -r Confirm
        Confirm=${Confirm,,}
    done

    if [[ "$Confirm" = "yes" ]]
    then
        break
    fi
done

echo "INFO World Name: $WorldName" >> logs/server.log

# Max players
echo "Enter maximum players (1-15):"
read -r MaxPlayers

while ! [[ "$MaxPlayers" =~ ^[0-9]+$ ]]
do
    echo "Please enter a number."
    read -r MaxPlayers
done

while [[ "$MaxPlayers" -gt 15 || "$MaxPlayers" -lt 1 ]]
do
    echo "Maximum players must be between 1 and 15."

    read -r MaxPlayers

    while ! [[ "$MaxPlayers" =~ ^[0-9]+$ ]]
    do
        echo "Please enter a number."
        read -r MaxPlayers
    done
done

echo "INFO Max Players: $MaxPlayers" >> logs/server.log


# Summary
echo "============================"
echo "      Setup Summary"
echo "============================"

echo "Game: $Game"
echo "Version: $Version"

echo "Difficulty: $Difficulty"
echo "Maximum Players: $MaxPlayers"
echo "World name: $WorldName"

echo "Hats: $HatChoice"
echo "Pet: $PetChoice"
echo "Glasses: $GlassesChoice"


# Start server
echo "Start server now? (yes/no)"
read -r Start

Start=${Start,,}

while [[ "$Start" != "yes" && "$Start" != "no" ]]
do
    echo "Please enter 'yes' or 'no'."
    read -r Start
    Start=${Start,,}
done

if [[ "$Start" = "yes" ]]
then
    echo "Server is now running!"
    echo "INFO Server Status: Online" >> logs/server.log 
else 
    echo "Server startup cancelled."
    echo "INFO Server Status: Offline" >> logs/server.log
fi


# Info
echo "Start Confirmation: $Start" >> logs/player.log
echo "World Name: $WorldName" >> logs/player.log
echo "Maximum Players: $MaxPlayers" >> logs/player.log
echo "Difficulty: $Difficulty" >> logs/player.log

echo "Hats $HatChoice" >> logs/player.log
echo "Pet $PetChoice" >> logs/player.log
echo "Glasses $GlassesChoice" >> logs/player.log


# Display Server Log
echo
echo "Server Log"
cat logs/server.log
