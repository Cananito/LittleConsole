
# LittleConsole

iOS framework library to embed a graphical logging console in the app.

<img src="https://raw.githubusercontent.com/Cananito/LittleConsole/master/Screenshots/CustomSize.png" width="50%" height="50%">

## Installation

Easiest way is to do it through [Carthage](https://github.com/Carthage/Carthage#getting-started).

Just add this to your Cartfile:

```
github "Cananito/LittleConsole"
```

You can also use git submodules and add the compiled framework to your **Embedded Binaries**.

And of course you could always just copy the `LittleConsole.swift` file into your project if that’s your cup of tea.

## Usage

To bring it up:

```swift
LittleConsole.show()
```

To remove it:

```swift
LittleConsole.disappear()
```

To log a message:

```swift
LittleConsole.log("A message!")
```

## To-dos

Please refer to issues marked as [enhancement](https://github.com/Cananito/LittleConsole/issues?q=is%3Aopen+is%3Aissue+label%3Aenhancement).
