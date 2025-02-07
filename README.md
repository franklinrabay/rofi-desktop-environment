# ROFI desktop environment

## A set of useful tools to use within your Window Manager

## Installation

Coming soon...

### Bluetooth

Coming soon...

### Display

Coming soon...

### Keyboard

The Keyboard menu relies on `localectl` to build up the list of available
Keyboard layouts and `setxkbmap` to set your preferred keyboard layout

If you have custom keyboard layouts mapped to `setxkbmap` you can map it
by adding a file called `keyboard.json` under `./custom` directory

It will look up for keys and an array of variants like the example below:

```[json]
{
  "rabay" : [
    "mac",
    "basic"
  ]
}
```

### Network

Coming soon...

### Styling

Coming soon...

### TODO List

The motivation for this tool is to have a simple TODO list that
can be used with a window manager keybinding.

On ./todo/launcher.sh there is availaable a simple TODO list
To use it, launch the script
Type the TODO item and press enter

To remove, use the arrow up and down to select the item and press enter

To cancel, press escape
