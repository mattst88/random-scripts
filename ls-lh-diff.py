#!/usr/bin/env python

import sys

from collections import namedtuple


def main():
    print(len(sys.argv))
    if len(sys.argv) != 3:
        print("Need two arguments")
        sys.exit(1)

    data = {}
    max_len = {key: 0 for key in ("file", "mode", "refs", "size")}

    addedfilesize = 0
    removedfilesize = 0
    changedfilesize = 0
    sizebefore = 0
    sizeafter = 0

    files = {
        "before": sys.argv[1],
        "after": sys.argv[2],
    }

    for f in files:
        with open(files[f], "r") as fp:
            for line in fp.readlines():
                # ls -lh --block-size=1 output
                # -rwxr-xr-x 1 root root 1011320 Aug 22 21:46 /build/brya/bin/udevadm
                (mode, refs, owner, group, size, _, _, _, file) = line.split(maxsplit=9)
                # (file, mode, refs, size) = line.split()
                if file not in data:
                    data[file] = {}
                data[file][f] = {
                    "file": file,
                    "mode": mode,
                    "refs": refs,
                    "size": size,
                }
                for c in max_len:
                    max_len[c] = max(max_len[c], len(data[file][f][c]))

    for file in data:
        if "before" in data[file] and "after" not in data[file]:
            print(f"-(removed) {file : <{max_len['file']}} (", end="")
        elif "after" in data[file] and "before" not in data[file]:
            print(f"+  (added) {file : <{max_len['file']}} (", end="")
        elif "before" in data[file] and "after" in data[file]:
            print(f"           {file : <{max_len['file']}} (", end="")
        else:
            assert False

        start = ""
        for d in ("mode", "refs", "size"):
            if d == "size":
                if "before" in data[file]:
                    sizebefore += int(data[file]["before"][d])
                if "after" in data[file]:
                    sizeafter += int(data[file]["after"][d])

            print(f"{start}{d}: ", end="")
            if "before" in data[file] and "after" in data[file]:
                if data[file]["before"][d] != data[file]["after"][d]:
                    print(
                        f"{data[file]['before'][d] : >{max_len[d]}} → {data[file]['after'][d] : >{max_len[d]}}",
                        end="",
                    )
                    if d == "size":
                        diff = int(data[file]["after"][d]) - int(
                            data[file]["before"][d]
                        )
                        percentdiff = 100 * diff / int(data[file]["before"][d])
                        print(
                            f", {diff:>+{max_len['size']}} bytes, {percentdiff:+.2f}%",
                            end="",
                        )
                        changedfilesize += int(data[file]["after"][d]) - int(
                            data[file]["before"][d]
                        )
                else:
                    print(f"{data[file]['before'][d] : >{max_len[d]}}", end="")

            elif "before" in data[file]:
                print(f"{data[file]['before'][d] : >{max_len[d]}}", end="")
                if d == "size":
                    removedfilesize -= int(data[file]["before"][d])
            elif "after" in data[file]:
                print(f"{data[file]['after'][d] : >{max_len[d]}}", end="")
                if d == "size":
                    addedfilesize += int(data[file]["after"][d])
            start = ", "
        print(")")

    print(f"      Size of files added: {addedfilesize:+} bytes")
    print(f"    Size of files removed: {removedfilesize:+} bytes")
    print(f"Net size of files changed: {changedfilesize:+} bytes")
    print(f" Size before: {sizebefore} bytes")
    print(f" Size after : {sizeafter} bytes")
    print(f" Size difference: {sizeafter - sizebefore:+} bytes")


if __name__ == "__main__":
    main()
