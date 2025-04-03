import os
import secrets
from pathlib import Path
import argparse

# Constants
ENV_FILE = "chat.env"
ENV_EXAMPLE = "chat.env.example"
ENV_VAR = "GPT_AGENT_API_KEY"

def generate_api_key() -> str:
    return secrets.token_hex(32)

def update_env_file(path: Path, key_name: str, new_key: str, dry_run: bool = False):
    updated = False
    lines = []
    if path.exists():
        lines = path.read_text().splitlines()
        for i, line in enumerate(lines):
            if line.startswith(f"{key_name}="):
                lines[i] = f"{key_name}={new_key}"
                updated = True
                break
    if not updated:
        lines.append(f"{key_name}={new_key}")

    if dry_run:
        print(f"[DRY-RUN] Would update {path.name}:\n" + "\n".join(lines))
        return

    path.write_text("\n".join(lines) + "\n")
    print(f"✅ Updated {path.name}")

def main():
    parser = argparse.ArgumentParser(description="GPT Agent API Key Rotator")
    parser.add_argument("--dry-run", action="store_true", help="Preview changes without applying them")
    args = parser.parse_args()

    current_key = os.getenv(ENV_VAR)
    if not current_key:
        raise EnvironmentError(f"{ENV_VAR} not found in environment. Make sure it's set via Makefile.")

    print("🔐 Rotating API key...")

    new_key = generate_api_key()

    update_env_file(Path(ENV_FILE), ENV_VAR, new_key, args.dry_run)
    update_env_file(Path(ENV_EXAMPLE), ENV_VAR, "your-api-key-here", args.dry_run)

    if args.dry_run:
        print("🧪 Dry-run complete. No changes written.")
    else:
        print("🔁 API key rotated successfully.")

if __name__ == "__main__":
    main()
