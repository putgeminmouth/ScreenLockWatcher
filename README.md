# ScreenLockWatcher
MacOS: Detect and run a file when the screen is un/locked.

## Usage
```
USAGE: args [--lock-file <lock-file>] [--unlock-file <unlock-file>] --open --execute [--verbose]

OPTIONS:
  --lock-file <lock-file> File to run when the screen is locked
  --unlock-file <unlock-file>
                          File to run when the screen is unlocked
  --open/--execute        'Open' uses /usr/bin/open to achieve similar effect as double-clicking it in Finder. Otherwise, the file must be executable.
  -v, --verbose
  -h, --help              Show help information.
```

For executable files, `--open` and `--execute` will be identical.

### Examples
Run shell scripts `.lock.sh` when the screen is locked and `.unlock.sh` when the screen is unlocked:
`ScreenLockWatcher --lock-file $HOME/.lock.sh --unlock-file $HOME/.unlock.sh --execute`

Open an image `lock.jpg` when the screen is locked and `unlock.jpg` when the screen is unlocked:
`ScreenLockWatcher --lock-file $HOME/lock.jpg --unlock-file $HOME/unlock.jpg --open`
