import os
import platform
import sys
from pathlib import Path
import shutil

if platform.system() == "FreeBSD":
    path = os.popen("readlink -f /usr/local/gcc-arm-embedded", mode = "r").read()
elif platform.system() == "Linux":
    path = "/usr"
elif platform.system() == "Windows":
    # Ask GCC for its own location, in case we've found a shim (e.g. Chocolatey)
    sysroot = os.popen("arm-none-eabi-gcc -print-sysroot", mode = "r")
    path = Path(sysroot.read()).parent.resolve().as_posix()
else:
    print(f"Don't know how to detect toolchain path on {platform.system()}", file=sys.stderr)
    sys.exit(1)

print(path)
