#!/usr/bin/env python3
"""Apply shared preferences without tracking machine-local Pi settings."""
import json
import os
from pathlib import Path
import shutil
import tempfile
import time

shared = json.loads(Path(__file__).with_name('settings.json').read_text())
target = Path.home() / '.pi/agent/settings.json'
target.parent.mkdir(parents=True, exist_ok=True)
local = json.loads(target.read_text()) if target.exists() else {}
if target.exists():
    backup = target.with_name(f'settings.json.backup.{time.time_ns()}')
    shutil.copyfile(target, backup)
    backup.chmod(0o600)
# Migrate either old installation form, avoiding duplicate extension loads.
local['packages'] = [p for p in local.get('packages', [])
                     if 'pi-customizations' not in (p if isinstance(p, str) else p.get('source', ''))]
local['extensions'] = [e for e in local.get('extensions', [])
                       if 'pi-customizations/' not in e]
local['extensions'] += shared['extensions']
local.update({k: v for k, v in shared.items() if k != 'extensions'})
fd, temp = tempfile.mkstemp(dir=target.parent, prefix='.settings-')
try:
    with os.fdopen(fd, 'w') as out:
        json.dump(local, out, indent=2)
        out.write('\n')
    os.replace(temp, target)  # Replace old symlinks rather than writing into Git.
finally:
    if os.path.exists(temp):
        os.unlink(temp)
print(f'Applied shared Pi preferences to {target}; model/provider settings preserved.')
