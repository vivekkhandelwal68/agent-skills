#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status, 
# except for the explicit conditional checks we handle manually.
set -e

echo "========================================="
echo "   Airflow Project Initializer Start     "
echo "========================================="

# ---------------------------------------------------------------------
# 1. Check and Install Astro CLI
# ---------------------------------------------------------------------
echo "Step 1: Checking Astro CLI availability..."

if command -v astro &> /dev/null; then
    echo "✔ Astro CLI is already installed."
    astro version
else
    echo "⚠️ Astro CLI not found. Detecting operating system for installation..."
    OS="$(uname -s)"
    
    case "${OS}" in
        Linux*)
            echo "Detected Linux. Installing Astro CLI via script..."
            mkdir -p $HOME/.local/bin
            
            # Download and execute the installer
            if curl -sL https://raw.githubusercontent.com/astronomer/astro-cli/main/godownloader.sh | bash -s -- -b "$HOME/.local/bin" v1.40.0; then
                echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
                # Export to current script session context so subsequent commands work immediately
                export PATH=$PATH:$HOME/.local/bin
                echo "✔ Astro CLI installed successfully on Linux."
            else
                echo "❌ Error: Failed to download or install Astro CLI. Tell end user the same and " >&2
                exit 1
            fi
            ;;
            
        Darwin*)
            echo "Detected macOS. Installing Astro CLI via Homebrew..."
            if command -v brew &> /dev/null; then
                brew install astro || { echo "❌ Error: Homebrew installation of Astro failed." >&2; exit 1; }
                echo "✔ Astro CLI installed successfully via Homebrew."
            else
                echo "❌ Error: Homebrew is not installed. Please install Homebrew first or install Astro CLI manually." >&2
                exit 1
            fi
            ;;
            
        CYGWIN*|MINGW32*|MSYS*|MINGW*)
            echo "Detected Windows environment (Bash emulation)."
            echo "Please run the following command in a Windows PowerShell terminal to install Astro CLI:"
            echo "👉 winget install -e --id Astronomer.Astro"
            echo "❌ Stopping execution. Please install Astro CLI and re-run this script."
            exit 1
            ;;
            
        *)
            echo "❌ Error: Unsupported Operating System: ${OS}" >&2
            exit 1
            ;;
    esac
fi

echo "-----------------------------------------"

# ---------------------------------------------------------------------
# 2. Check for Docker Presence & Configure Mode
# ---------------------------------------------------------------------
echo "Step 2: Checking for Docker runtime..."

# Disable 'set -e' temporarily because docker --version returning an error shouldn't crash the script
set +e
command -v docker &> /dev/null
DOCKER_CHECK=$?
set -e

if [ $DOCKER_CHECK -eq 0 ]; then
    echo "✔ Docker detected:"
    docker --version
    echo "Configuring Astro to run in Container mode..."
   astro config set container.binary docker -g || { echo "❌ Error: Failed to set container configuration." >&2; exit 1; }
else
    echo "⚠️ Docker is missing or not running."
    echo "Configuring Astro to run in Standalone mode..."
   astro config set dev.mode standalone || { echo "❌ Error: Failed to set standalone configuration." >&2; exit 1; }
fi

echo "-----------------------------------------"

# ---------------------------------------------------------------------
# 3. Initialize & Configure the Astro Project
# ---------------------------------------------------------------------
echo "Step 3: Checking for existing Astro project structure..."

if [ -f "Dockerfile" ] && [ -d ".astro" ] && [ -d "dags" ]; then
    echo "ℹ️ An Astro project configuration (Dockerfile or .astro directory) already exists."
    echo "Skipping initialization to protect your existing environment."
else
    echo "🚀 No existing Astro project found. Initializing fresh Astro project..."
    echo "creating temp-astro temp directory and intialize airflow project in it..."
    mkdir temp-astro && cd temp-astro
    astro dev init || { echo "❌ Error: 'astro dev init' failed to execute." >&2; exit 1; }
    echo "copying files from temp-astro to current directory..."
    mv * .* .. 2>/dev/null; cd .. && rm -rfgit  temp-astro
    echo "✔ Astro project initialized successfully."
fi

echo "========================================="
echo " 🎉 Airflow Environment Setup Complete! "
echo "========================================="