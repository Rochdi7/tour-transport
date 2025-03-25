#!/bin/bash

# push.sh - Tour Transport Project Git Helper
# Automates commits and pushes with project-specific standards

# Project-specific commit types
TYPES=(
  "feat: New transport/tour feature"
  "fix: Bug fix in booking system"
  "docs: Tour documentation updates"
  "style: UI/style improvements"
  "refactor: Code restructuring"
  "perf: Booking performance optimization"
  "test: Tour route testing"
  "chore: Maintenance tasks"
  "config: Environment setup"
)

# Recommended initial commits for Tour Transport Project
INITIAL_COMMITS=(
  "config: Initialize Laravel project with tour transport dependencies"
  "feat: Add basic tour listing functionality"
  "feat: Implement contact form for tour inquiries"
  "docs: Add README with project overview"
  "style: Add initial CSS for tour cards"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Functions ---
show_initial_commits() {
  echo -e "${CYAN}Recommended initial commits for Tour Transport Project:${NC}"
  for i in "${!INITIAL_COMMITS[@]}"; do
    echo "  $((i+1)). ${INITIAL_COMMITS[$i]}"
  done
}

# --- Main Script ---
echo -e "${CYAN}=== Tour Transport Project Git Helper ===${NC}"

# Check if git exists
if ! command -v git &> /dev/null; then
  echo -e "${RED}✗ Git not found. Please install Git first.${NC}"
  exit 1
fi

# Check if in git repo
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
  echo -e "${YELLOW}⚠ Initializing new Git repository...${NC}"
  git init
fi

# Show help if no args
if [ $# -eq 0 ]; then
  echo -e "\n${YELLOW}Usage:${NC}"
  echo "  ./push.sh \"message\" [type] [branch]"
  echo "  ./push.sh --init # Setup initial commits"
  
  echo -e "\n${YELLOW}Project Commit Types:${NC}"
  for type in "${TYPES[@]}"; do
    echo "  ${type%%:*}"  # Show just the prefix
  done
  
  show_initial_commits
  exit 0
fi

# Special initialization mode
if [ "$1" == "--init" ]; then
  echo -e "${GREEN}Setting up initial project commits...${NC}"
  
  for commit in "${INITIAL_COMMITS[@]}"; do
    echo -e "${YELLOW}Committing: ${commit}${NC}"
    git add .
    git commit -m "$commit"
    
    if [ $? -ne 0 ]; then
      echo -e "${RED}Error: Commit failed on '${commit}'${NC}"
      exit 1
    fi
  done
  
  echo -e "${GREEN}✓ Initial commits complete. Now run:${NC}"
  echo "git remote add origin YOUR_REPO_URL"
  echo "git push -u origin main"
  exit 0
fi

# Normal commit mode
MESSAGE="$1"
TYPE="${2:-}"
BRANCH="${3:-$(git branch --show-current)}"

# Process commit type
if [ -n "$TYPE" ]; then
  valid_type=false
  for t in "${TYPES[@]}"; do
    if [ "$TYPE" = "${t%%:*}" ]; then
      valid_type=true
      MESSAGE="$TYPE: $MESSAGE"
      break
    fi
  done
  
  if [ "$valid_type" = false ]; then
    echo -e "${RED}Error: Invalid commit type.${NC}"
    echo -e "${YELLOW}Valid types for Tour Transport:${NC}"
    for type in "${TYPES[@]}"; do
      echo "  ${type%%:*}"
    done
    exit 1
  fi
fi

# Execute Git operations
echo -e "${YELLOW}Staging changes...${NC}"
git add .

echo -e "${YELLOW}Committing: ${MESSAGE}${NC}"
git commit -m "$MESSAGE"

if [ $? -ne 0 ]; then
  echo -e "${RED}✗ Commit failed${NC}"
  exit 1
fi

echo -e "${YELLOW}Pushing to ${BRANCH}...${NC}"
git push origin "$BRANCH"

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✓ Successfully pushed to ${BRANCH}${NC}"
else
  echo -e "${RED}✗ Push failed. Trying to set upstream...${NC}"
  git push --set-upstream origin "$BRANCH"
fi