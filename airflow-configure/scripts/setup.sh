#!/bin/bash

# Determine project name from the current working directory
PROJECT_NAME=$(basename "$PWD")
SECRETS_DIR="$HOME/.airflow_secrets/$PROJECT_NAME"
SETTINGS_FILE="airflow_settings.yaml"

# Handle airflow_settings.yaml migration
if [ -f "$SETTINGS_FILE" ]; then
    echo "🔒 Found $SETTINGS_FILE. Moving to secure directory..."
    
    # Create the secret directory if it doesn't exist
    mkdir -p "$SECRETS_DIR"
    
    # Move the file
    mv "$SETTINGS_FILE" "$SECRETS_DIR/$SETTINGS_FILE"
    
    echo "ℹ️  $SETTINGS_FILE has been moved to $SECRETS_DIR/$SETTINGS_FILE"
    echo "⚠️  Please configure it manually in its new location."
    echo ""
    echo "💡 To apply these settings:"
    echo "   • If Airflow is ALREADY running, run:"
    echo "     astro dev object import -s \"$SECRETS_DIR/$SETTINGS_FILE\""
    echo ""
    echo "   • If Airflow is NOT running and you want to start it with these settings, run:"
    echo "     astro dev start -s \"$SECRETS_DIR/$SETTINGS_FILE\""
    echo "========================================="
    echo ""
fi

echo "========================================="
echo "🚀 Starting Astro Dev Environment..."
echo "========================================="
echo ""

# Verify Astro CLI is installed before starting
if command -v astro &> /dev/null; then
    astro dev start
else
    echo "❌ Error: 'astro' CLI tool is not installed or not in your PATH."
    echo "Please install it or run this script in an environment where it is available."
    exit 1
fi