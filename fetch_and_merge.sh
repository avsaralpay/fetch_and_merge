#!/bin/bash

# Set the source directory to the current directory
SOURCE_DIR=$(pwd)

echo "Fetching and merging main repository in $SOURCE_DIR"

# Check if the current directory is a Git repository
if [ -d ".git" ]; then
    # Get remote name
    REMOTE_NAME=$(git remote | head -n 1)

    if [ -n "$REMOTE_NAME" ]; then
        git fetch "$REMOTE_NAME"
        git checkout master   #checkouta bak
        git merge "$REMOTE_NAME"/master

        # If there are any conflicts, abort the script
        if [ $? -ne 0 ]; then
            echo "There are conflicts in the main repository. Please resolve them and run the script again."
            exit 1
        else
            echo "No conflicts in the main repository"
            echo "Successfully fetched and merged the main repository"
        fi
    else
        echo "No remote found in the main repository. Skipping."
    fi
else
    echo "The current directory is not a Git repository. Exiting."
    exit 1
fi

# Prompt the user for confirmation to commit, and push changes
read -p "Do you want to commit, and push the changes? (y/n): " CONFIRM

if [ "$CONFIRM" = "y" ]; then
    # Stage the changes
    git add .

    # Prompt the user for a commit message
    read -p "Enter a commit message: " COMMIT_MESSAGE

    # Commit the changes
    git commit -m "$COMMIT_MESSAGE"

    # Prompt the user for their GitHub username and token
    read -p "Enter your GitHub username: " USERNAME
    read -sp "Enter your GitHub token: " TOKEN
    echo

    # Push the changes to the remote repository
    git push REMOTE_NAME HEAD:master

else
    echo "Changes were not committed, or pushed."
fi
