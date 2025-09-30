#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = ["loguru", "watchdog"]
# ///

import os
import subprocess
import sys
import time

from loguru import logger
from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer

# --- Configuration ---
REPO_PATHS = [
    f"{os.path.expanduser('~')}/git/dotfiles",
    f"{os.path.expanduser('~')}/git/mac-playbook",
    f"{os.path.expanduser('~')}/git/scripts",
]

COMMIT_MESSAGE = "Auto-sync commit"
# How often to check for events and trigger sync if changes happened
SYNC_INTERVAL_SECONDS = 60 * 60  # Every hour.

log_params = {
    "level": "DEBUG",
    "format": "{message}",
    "colorize": True,
    "backtrace": True,
    "diagnose": True,  # Set to False in production.
}

logger.remove()
_ = logger.add(sys.stderr, **log_params)


# --- Git commands ---
def git_sync(repo_path, commit_message):
    """
    Performs git add, commit, pull --rebase, and push.
    """
    logger.debug(
        f"[{time.ctime()}] Changes detected in {repo_path}. Initiating Git sync...",
    )
    try:
        # Change to the repository directory
        os.chdir(repo_path)

        # Add all changes
        subprocess.run(["git", "add", "."], check=True, capture_output=True)
        logger.debug(f"[{time.ctime()}] git add . completed.")

        # Check if there are any changes to commit
        status_output = subprocess.run(
            ["git", "status", "--porcelain"],
            check=True,
            capture_output=True,
            text=True,
        )
        if status_output.stdout.strip():
            # Commit changes
            subprocess.run(
                ["git", "commit", "-m", commit_message],
                check=True,
                capture_output=True,
            )
            logger.debug(
                f"[{time.ctime()}] git commit -m '{commit_message}' completed.",
            )
        # else:
        logger.debug(f"[{time.ctime()}] No changes to commit.")

        # Pull with rebase (to avoid merge commits for automatic sync)
        subprocess.run(["git", "pull", "--rebase"], check=True, capture_output=True)
        logger.debug(f"[{time.ctime()}] git pull --rebase completed.")

        # Push changes
        subprocess.run(["git", "push"], check=True, capture_output=True)
        logger.debug(f"[{time.ctime()}] git push completed successfully.")

    except subprocess.CalledProcessError as e:
        logger.error(f"[{time.ctime()}] Git command failed: {e.cmd}")
        logger.error(f"[{time.ctime()}] STDOUT: {e.stdout.decode()}")
        prilogger.errornt(f"[{time.ctime()}] STDERR: {e.stderr.decode()}")
        logger.error(f"[{time.ctime()}] Sync failed. Please resolve manually.")
    except Exception as e:
        logger.error(f"[{time.ctime()}] An unexpected error occurred: {e}")
    finally:
        # Change back to the original directory (optional, but good practice)
        # You might want to store the original working directory if the script is run from various locations
        pass


# --- Watchdog Event Handler ---
class GitEventHandler(FileSystemEventHandler):
    def __init__(self, repo_path, commit_message):
        super().__init__()
        self.repo_path = repo_path
        self.commit_message = commit_message
        self.last_sync_time = time.time()  # To prevent rapid-fire syncs

    def on_any_event(self, event):
        # Ignore events on the .git directory itself to avoid infinite loops
        if ".git" in event.src_path:
            return

        # Debounce: Only sync if enough time has passed since the last sync
        if time.time() - self.last_sync_time > SYNC_INTERVAL_SECONDS:
            logger.debug(
                f"[{time.ctime()}] File system event detected: {event.event_type} - {event.src_path}",
            )
            git_sync(self.repo_path, self.commit_message)
            self.last_sync_time = time.time()


# --- Main execution ---
if __name__ == "__main__":
    observers = []  # List to hold all observer instances.

    logger.info(f"[{time.ctime()}] Starting Git Watcher for multiple repositories...")

    for repo_path in REPO_PATHS:
        if not os.path.isdir(repo_path):
            logger.error(
                f"Error: Repository path '{repo_path}' does not exist or is not a directory. Skipping.",
            )
            continue

        event_handler = GitEventHandler(repo_path, COMMIT_MESSAGE)
        observer = Observer()
        # Schedule the observer to watch the current repo path recursively
        observer.schedule(event_handler, repo_path, recursive=True)
        observers.append(observer)  # Add observer to our list

        logger.info(f"[{time.ctime()}] Watching repository: {repo_path}")

    if not observers:
        logger.error("No valid repositories configured. Exiting.")
        exit(1)

    logger.info(
        f"[{time.ctime()}] Sync interval: {SYNC_INTERVAL_SECONDS} seconds after a change.",
    )
    logger.info("Press Ctrl+C to stop all watchers.")

    # Start all observers
    for observer in observers:
        observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        logger.error(
            f"[{time.ctime()}] KeyboardInterrupt detected. Stopping all Git watchers...",
        )
        for observer in observers:
            observer.stop()  # Stop each observer
    finally:
        for observer in observers:
            observer.join()  # Wait for all observer threads to finish
        logger.info(f"[{time.ctime()}] All Git watchers stopped.")
