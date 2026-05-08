#!/bin/bash

REPO=~/bernz-homelab
LOG=/tmp/git-commit.log

cd $REPO || exit 1

# Copy latest configs into repo
cp ~/n8n/docker-compose.yml $REPO/n8n/docker-compose.yml
cp ~/homepage/config/services.yaml $REPO/homepage/config/services.yaml
cp ~/homepage/config/widgets.yaml $REPO/homepage/config/widgets.yaml
cp ~/homepage/config/settings.yaml $REPO/homepage/config/settings.yaml

# Stage all changes
git add .

# Check if anything changed
if git diff --cached --quiet; then
  echo "No changes to commit" | tee $LOG
  exit 0
fi

# Commit and push
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
git commit -m "auto-backup: $TIMESTAMP" >> $LOG 2>&1
GIT_SSH_COMMAND="ssh -i ~/.ssh/github" git push >> $LOG 2>&1

if [ $? -eq 0 ]; then
  echo "SUCCESS" | tee -a $LOG
  exit 0
else
  echo "FAILED" | tee -a $LOG
  exit 1
fi
