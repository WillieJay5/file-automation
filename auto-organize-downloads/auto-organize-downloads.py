import os
import shutil
from pathlib import Path

DOWNLOADS = Path.home() / "Downloads"
FILE_TYPES = {
    "Images": [".png", ".jpg", ".jpeg", ".gif", ".JPG"],
    "Documents": [".pdf", ".docx", ".txt", ".xlsx"],
    "Installers": [".exe", ".msi", ".dmg"],
    "Archives": [".zip", ".rar", ".tar", ".gz"],
    "Videos": [".mp4", ".mov", ".avi"],
}

def organize_downloads():
    for file in DOWNLOADS.iterdir():
        if file.is_file():
            moved = False
            for folder, extensions in FILE_TYPES.items():
                if file.suffix.lower() in extensions:
                    target_dir = DOWNLOADS / folder
                    target_dir.mkdir(exist_ok=True)
                    shutil.move(str(file), target_dir / file.name)
                    moved = True
                    break
            if not moved:
                misc_dir = DOWNLOADS / "Misc"
                misc_dir.mkdir(exist_ok=True)
                shutil.move(str(file), misc_dir / file.name)

organize_downloads()
