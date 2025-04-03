from invoke import task
import os
import secrets
from pathlib import Path

@task
def check_env(c):
    if not Path(".env/bin/activate").exists():
        print("❌ .env not found. Run: python -m venv .env")
        return
    print("✅ .env found")

    path = Path("chat.env")
    if not path.exists():
        print("🔐 Creating chat.env...")
        path.write_text("")

    content = path.read_text()
    if "GPT_AGENT_API_KEY" not in content:
        key = secrets.token_hex(32)
        path.write_text(f"GPT_AGENT_API_KEY={key}\n")
        print("✅ API key created")
    else:
        print("✅ API key already exists")

@task
def run_tool(c):
    check_env(c)
    from dotenv import load_dotenv
    load_dotenv("chat.env")
    os.system(". .env/bin/activate && python rotate_api_key.py")
