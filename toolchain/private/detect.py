import os
import platform
import sys

if platform.system() == "FreeBSD":
    path = os.popen("readlink -f /usr/local/gcc-arm-embedded", mode = "r").read()
elif platform.system() == "Linux":
    path = "/usr"
else:
    print(f"Don't know how to detect toolchain path on {platform.system()}", file=sys.stderr)
    sys.exit(1)

print(path)
