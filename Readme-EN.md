# ZZClang-format

Xcode10 code formatting tool written according to the existing Xcode10 structure. I miss the classmates of Clang-format, and can use it. **Recently rewritten this plugin with swift, supports swift formatting, supports xcode9 / 10, please move on: [ZZXcodeFormat](https://github.com/V5zhou/ZZXcodeFormat)**

## Installation method

Download ZZClang-format and run one_key_install directly, so easy.

## What does one_key_install do for you?

1. Add the .clang-format configuration file to your personal folder ~, the rule configuration of the clang-format script is here, of course you can personalize the configuration, refer to here
2. Check and add Xcode's UUID
3. Compile the plugin
4. Check your gem source and modify it to the latest https://gems.ruby-china.com/
5. Check if update_xcode_plugins is installed, install if not
6. Execute unsign

After executing it, restart Xcode. If you select LoadBundle in the popup box, you can see ZZClang-format in the Xcode-> Edit column.

## Features

ZZClang-format includes the following functions:

1. Format the current Focus window: FocusFile
2. Format multiple selected files: SelectFiles
3. Format the currently selected text area: SelectText
4. Configure whether to save when formatting: ZZFormatOnSave

## Extra configuration

You can configure shortcut keys for easier use. For example, to add a shortcut to FocusFile:

System Settings-> Keyboard-> Shortcuts-> Application Shortcuts-> Click Add-> Application Select Xcode, enter FocusFile for the menu title, and set the keyboard shortcut to shift + command + L.
Open Xcode, click on ZZClang-foramt, and you will find it in the menu we added.

Attach a clang-format FocusFile effect

![Focus](https://github.com/V5zhou/ZZClang-format/blob/master/ZZClang-format/FocusFile%E6%A0%BC%E5%BC%8F%E5%8C%96.gif)

---

## 1. Summary of problems encountered

1. show in finder fails after unsign?

Recently, I found a bug that when I execute [unsign](https://github.com/inket/update_xcode_plugins/blob/master/README.md), I run the showinfiner on the new 10.14 system (the black theme) and run infinite circles.

*Solution:* refer to [自签名](https://github.com/XVimProject/XVim/blob/master/INSTALL_Xcode8.md)

1. Close Xcode
2. Open the keychain and create a self-signed certificate: Keychain Access-> Keychain Access-> Certificate Assistant-> Create Certificate. Create Certificate
3. Open the terminal to sign with this certificate (will wait for a long time):

> sudo codesign -f -s XcodeSigner /Applications/Xcode.app

*XcodeSigner named you just now*

4. After re-signing successfully, open Xcode and compile the project file of the plug-in. Restart Xcode and allow the plugin to load when you see the popup.


## 2. The codesign_allocate helper tool cannot be found or used

*Solution:*

See where the current command is located

> locate codesign_allocate

If prompted does not exist, then

> ~~cp /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/codesign_allocate~~/usr/bincp command has failed

See: Operation not permitted

Then copy it manually, open the two finder windows manually, go to the folder /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/codesign_allocate and /usr/bin, copy the file codesign_allocate to /usr/bin.

If the manual copy does not pass, you need to close sip, there will be no restrictions

Is it different to execute the following statement?

> locate codesign_allocate

After Xcode 10.2 verification, you need to restore the xcode signature first, and then self-sign.

> sudo update_xcode_plugins --restore

Self-signed:

> sudo codesign -f -s XcodeSigner /Applications/Xcode.app

waiting. . . OK after a while

Referenced from https://www.jianshu.com/p/a62c9efb1e53
