#!/usr/bin/env python3.12

import argparse
import pathlib
import subprocess
import sys
from typing import Mapping

arg_parser = argparse.ArgumentParser()
arg_parser.add_argument("ROOT", type=pathlib.Path)
arg_parser.add_argument("RELATIVE", type=pathlib.Path)

EXTS = ["", ".dylib", ".so"]


def find_binaries(fixup_root: pathlib.Path) -> dict[str, pathlib.Path]:
    assert fixup_root.is_dir()
    result = {}
    for file in fixup_root.glob("**/*"):
        if not is_executable(file):
            continue
        symlink_dest = file.resolve()
        file_key = path_key(file)
        assert (
            file_key not in result or result[file_key] == symlink_dest
        ), f"Saw {file_key} twice: {result[file_key]} and {file}"
        result[file_key] = symlink_dest
    return result


def path_key(path: pathlib.Path) -> str:
    framework_parts = None
    for p in path.parts:
        if framework_parts is None and p.endswith(".framework"):
            framework_parts = []
        if framework_parts is not None:
            framework_parts.append(p)
    if framework_parts:
        return "/".join(framework_parts)
    return path.name


def is_executable(path: pathlib.Path) -> bool:
    if not path.is_file() or path.suffix not in EXTS:
        return False
    try:
        output = subprocess.check_output(
            ["file", "--brief", str(path.absolute())], text=True
        )
    except Exception:
        print(
            "Error while checking type of file: " + str(path.absolute()),
            file=sys.stderr,
        )
        raise
    first_line = output.split("\n")[0]
    return "Mach-O" in first_line and "binary" in first_line


def lib_references(executable_path: pathlib.Path):
    result = subprocess.check_output(
        ["otool", "-arch", "all", "-L", str(executable_path)], text=True
    )
    # Filter out lines which do not begin with some whitespace. These are
    # headers listing the install name of the target and the architecture.
    libraries = [line for line in result.splitlines() if line[0].isspace()]
    libraries = [line.strip().split()[0] for line in libraries]
    libraries = [pathlib.Path(lib) for lib in libraries]
    return libraries


def make_new_path(relative_path, bins_map: Mapping[str, pathlib.Path], r: pathlib.Path) -> str:
    return f"@executable_path/{bins_map[path_key(r)].relative_to(relative_path, walk_up=True)}"


def main():
    args = arg_parser.parse_args()
    bins_map = find_binaries(args.ROOT)
    relative_to_path = args.RELATIVE.resolve()
    for filename, canon_path in bins_map.items():
        install_name_tool_args = ["install_name_tool"]
        print(f"{filename} -> {canon_path}")
        new_id_path = make_new_path(relative_to_path, bins_map, canon_path)
        print("New ID path:", new_id_path)
        install_name_tool_args += ["-id", new_id_path]
        for r in lib_references(canon_path):
            print(f"  {r}")
            if path_key(r) in bins_map:
                print(f"{bins_map[path_key(r)]} relative_to {relative_to_path}")
                new_path = make_new_path(relative_to_path, bins_map, r)
                print(f"    {new_path} ***")
                install_name_tool_args += ["-change", str(r), new_path]
        subprocess.check_call(install_name_tool_args + [str(canon_path)])


if __name__ == "__main__":
    main()