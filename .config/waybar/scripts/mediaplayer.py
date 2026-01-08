#!/usr/bin/env python3

import json
import subprocess
import sys

def get_player_status():
    try:
        # Get list of active players
        players = subprocess.run(['playerctl', '-l'], capture_output=True, text=True)
        if players.returncode != 0 or not players.stdout.strip():
            return None

        # Use the first available player
        player = players.stdout.strip().split('\n')[0]

        # Get player status
        status = subprocess.run(['playerctl', '-p', player, 'status'],
                              capture_output=True, text=True)

        if status.returncode != 0:
            return None

        player_status = status.stdout.strip()

        # Get metadata
        artist = subprocess.run(['playerctl', '-p', player, 'metadata', 'artist'],
                               capture_output=True, text=True).stdout.strip()
        title = subprocess.run(['playerctl', '-p', player, 'metadata', 'title'],
                              capture_output=True, text=True).stdout.strip()

        # Determine icon based on player and status
        if 'spotify' in player.lower():
            icon = 'spotify'
        else:
            icon = 'default'

        # Format text
        if artist and title:
            text = f"{artist} - {title}"
        elif title:
            text = title
        else:
            text = "Unknown"

        # Limit length
        if len(text) > 35:
            text = text[:32] + "..."

        # Add status indicator
        if player_status == "Playing":
            status_icon = "▶"
        elif player_status == "Paused":
            status_icon = "⏸"
        else:
            status_icon = "⏹"

        return {
            "text": f"{status_icon} {text}",
            "tooltip": f"Player: {player}\nStatus: {player_status}\nArtist: {artist}\nTitle: {title}",
            "class": player_status.lower(),
            "icon": icon
        }

    except Exception as e:
        return None

def main():
    status = get_player_status()
    if status:
        print(json.dumps(status))
    else:
        print(json.dumps({"text": "", "tooltip": "No media playing", "class": "stopped"}))

if __name__ == "__main__":
    main()
