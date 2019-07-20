
# BashLauncher

BashLauncher is a simple script that allows:

1. Keeping all your bash scripts organized in one folder
1. Easy access and autocompletion for running any command in that folder (using the "x" command)

## Usage
First, clone/fork this repo in your home folder:
```
cd
git clone https://github.com/dev4light/bashlauncher.git .bashlauncher
```

Next, run init.sh so that the script gets setup:

```
. .bashlauncher/init.sh
```
This will automatically update your .profile so that each time you login, BashLauncher is started up.
Also, it will update your PATH variable 

## Commands
| Command | Arguments | Description |
|--|--|--|
| x | `<command>` | Runs a command from your commands folder.<br> Pressing `<TAB>` after typing `x` will autocomplete with only the files in from your commands folder |
| x0 | - | changes folder to .bashlauncher |
| c | - | clears the screen |

New commands can be defined by editing the init.sh file, specifically the **Aliases** function.

xx

