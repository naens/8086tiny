# 8086tiny Documentation

8086tiny is a compact, PC XT-style emulator/VM with an 8086/186-compatible CPU core, BIOS, floppy/hard-disk support, keyboard handling, timer/RTC emulation, and ANSI terminal text output.

## Current fork status

- SDL-specific keyboard paths were removed from BIOS keyboard handling.
- Build is SDL-free (`make` builds `bios.bin` and `8086tiny`).
- Text dimensions are runtime-driven rather than fixed `80x25`.

At startup, `8086tiny` reads terminal size using `ioctl(TIOCGWINSZ)` and uses:

- `cols = ws_col`
- `rows = ws_row`

Values are clamped to BIOS-safe bounds:

- columns: `1..255` (fallback default `80`)
- rows: `1..255` (fallback default `25`)

BIOS data area values are initialized from these runtime values (including `rows-1` where required by BIOS conventions).

## Emulated machine profile

- Intel 8086/186-compatible CPU behavior
- ~1MB RAM model
- 3.5" floppy support (720KB / 1.44MB)
- Single hard disk support (classic XT-style geometry, up to ~528MB)
- CGA-like text-mode behavior via terminal output
- PIT, RTC, keyboard controller behavior, and PC speaker-related I/O behavior

## Build

```sh
make
```

Build outputs:

- `bios.bin` (from `bios.asm`)
- `8086tiny` (from `8086tiny.c`)

Clean:

```sh
make clean
```

## Run

```sh
./8086tiny bios.bin fd.img [@]hd.img
```

- Prefix hard disk image with `@` to boot from hard disk.
- Terminal mode is configured by `8086tiny` at startup; no wrapper script is required.

## Keyboard behavior (text mode)

For terminal text mode, special key sequences are used for combinations not directly returned as plain ASCII input:

- `Ctrl+A`, then key => `Alt+key`
- `Ctrl+F`, then number => function key (`F1..F10`)
- `Ctrl+F`, then `Ctrl+A` => literal `Ctrl+A`
- `Ctrl+F`, then `Ctrl+F` => literal `Ctrl+F`
- `Ctrl+F`, then `O` => Page Down
- `Ctrl+F`, then `Q` => Page Up

Keyboard polling frequency is controlled by `KEYBOARD_TIMER_UPDATE_DELAY`.

## Text mode and terminal behavior

- ANSI escape sequences are used for text rendering, scrolling, color/attributes, and cursor control.
- Screen operations and cursor math use runtime `rows`/`cols` selected at startup.
- Best results require an ANSI-capable terminal.
- If terminal size cannot be queried, emulator falls back to `80x25`.

## Disk image notes

Floppy:

- 720KB and 1.44MB image formats are supported.

Hard disk:

- Supports XT-style CHS geometry derivation from flat image size.
- Not all host file size may be usable due to CHS mapping simplification.

Basic workflow to prepare a hard disk image under DOS in the emulator:

1. Create a zero-filled image file (up to ~528MB).
2. Boot emulator and run `FDISK`.
3. Reboot and run `FORMAT C:` (or `FORMAT C: /S`).

## Historical compatibility notes

The upstream project historically reported successful testing with software including DOS variants, Windows 3.0-era applications, and period games/tooling. Treat this as historical context rather than a strict compatibility guarantee for this fork.
