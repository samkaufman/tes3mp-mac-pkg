# TES3MP MacOS Packaging

This repository contains script which package TES3MP, an open-source multiplayer client
for the game Morrowind, for MacOS. It provides universal binaries compatible with both
Intel- and Apple Silicon-based Macs.

**Note:** While the client works fine on Apple Silicon- and Intel-based Macs,
*`tes3mp-server` runs well only on Intel-based Macs.

## Installation
To install, download the latest `.dmg` file from the GitHub Releases page. Open the file
and drag the `.app` to your Applications folder.

## Building from Source
To build from source, clone the repository and run `./build.sh` from the root of the
source directory on a MacOS machine.

For building from source, you will need:
- Xcode 15 Command Line Tools
- `brew install coreutils gnu-sed nasm ninja meson patchutils create-dmg`

## License
This repository is licensed under the GNU General Public License v3.0 - see the
[LICENSE](LICENSE) file for details.

## Disclaimer
This project is not affiliated with or endorsed by Bethesda, OpenMW, or TES3MP.