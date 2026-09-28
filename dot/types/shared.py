from pathlib import Path

Distro = str

# Repo root, resolved from this file so `dots` works from any cwd (editable install)
REPO_ROOT = Path(__file__).resolve().parents[2]
