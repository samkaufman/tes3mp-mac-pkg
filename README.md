# TES3MP macOS Packages

This repository contains script which package TES3MP, an open-source multiplayer client
for the game Morrowind, for MacOS. It provides universal binaries compatible with both
Intel- and Apple Silicon-based Macs.

**Note:** While the client works fine on Apple Silicon- and Intel-based Macs,
`tes3mp-server` runs well only on Intel-based Macs.

## Installation & Running
To install, download the latest `.dmg` file from the GitHub Releases page. Open the file
and drag the `.app` to your Applications folder.

To run the client, just double-click the application.

The first time you run the application, you may need to right-click the `.app` and
select "Open" due to the app being unsigned. This process will prompt you to confirm
that you really want to open the application. After doing this once, you should be able
run the application normally.

### Server
To run the server on an Intel-based Mac, you'll need to open a terminal and run:
```bash
/Applications/TES3MP.app/Contents/MacOS/tes3mp-server
```

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