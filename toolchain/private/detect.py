import os
import platform
import sys
from pathlib import Path
import shutil

if platform.system() == "FreeBSD":
    path = os.popen("readlink -f /usr/local/gcc-arm-embedded", mode = "r").read()
elif platform.system() == "Linux":
    path = "/usr"
elif platform.system() == "Darwin":
    gcc = shutil.which('arm-none-eabi-gcc')
    if not gcc:
        print(f"arm-none-eabi-gcc not found on PATH", file=sys.stderr)
        sys.exit(1)
    # Ask GCC for its own location, in case we've found a shim (e.g. Chocolatey)
    sysroot = os.popen(f"{gcc} -print-sysroot", mode = "r").read()
    if sysroot and not sysroot.isspace():
        path = Path(sysroot).parent.resolve().as_posix()
    else:
        # Some installs don't know their own sysroot. Use the binary's location.
        path = Path(gcc).parent.parent.resolve().as_posix()
elif platform.system() == "Windows":
    gcc = shutil.which('arm-none-eabi-gcc')
    if not gcc:
        print(f"arm-none-eabi-gcc not found on PATH", file=sys.stderr)
        sys.exit(1)
    # Ask GCC for its own location, in case we've found a shim (e.g. Chocolatey)
    sysroot = os.popen(f"{gcc} -print-sysroot", mode = "r").read()
    if sysroot and not sysroot.isspace():
        path = Path(sysroot).parent.resolve().as_posix()
    else:
        # Some installs don't know their own sysroot. Use the binary's location.
        path = Path(gcc).parent.parent.resolve().as_posix()
else:
    print(f"Don't know how to detect toolchain path on {platform.system()}", file=sys.stderr)
    sys.exit(1)

print(path)
