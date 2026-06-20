import subprocess
import os
import sys

def run_project_setup():
    print("\n⚡ [UV-Initializer] Syncing native UV Project Workspace...")
    
    # 1. Initialize the project workspace if missing
    if not os.path.exists("pyproject.toml"):
        print("📂 [UV-Initializer] Initializing pyproject.toml with Python 3.13...")
        # This sets up the project format and configures it to target Python 3.13
        subprocess.run(["uv", "init", "--python", "3.13"], check=True)
    else:
        print("✅ [UV-Initializer] Existing pyproject.toml found.")
        
    # 2. Automatically parse and append requirements into pyproject.toml
    if os.path.exists("requirements.txt"):
        print("📥 [UV-Initializer] Migrating requirements.txt items directly into pyproject.toml...")
        # The -r flag reads the file and populates [project.dependencies] automatically
        subprocess.run(["uv", "add", "-r", "requirements.txt"], check=True)
        print("✅ [UV-Initializer] Dependencies successfully registered in pyproject.toml.")
    else:
        print("📝 [UV-Initializer] No requirements.txt found to import.")

    print("🏁 [UV-Initializer] Workspace synced successfully!\n")

if __name__ == "__main__":
    try:
        run_project_setup()
    except subprocess.CalledProcessError as e:
        print(f"❌ [UV-Initializer] Setup failed: {e}")
        sys.exit(1)