# fcitx-remote for macOS

## What is this project for?

On Linux and BSD-based systems, there is an input method framework called fcitx.
Fcitx is automatable to the extent that you can programmatically disable non-Latin input methods (such as Chinese IME) when leaving insert mode in Vim or Neovim.
This is very useful and I have always missed this feature when working with Chinese input methods on macOS.

This project aims to provide a limited solution to this problem.

## What this project can do for you

This program can toggle between two pre-defined input sources, e. g. Chinese Zhuyin and US Keyboard.
My own workflow is based on a customized Polish Dvorak keyboard layout and Sogou Wubi Pinyin Chinese input method.
Since my Chinese input method relies on a QWERTY layout and my main input method is Dvorak-based, programmatically switching between these two leaves the input in a dirty state when the Wubi keyboard is activated, but the keyboard layout is stuck at Dvorak.
This can be solved by switching the keyboard layout to US keyboard before switching back to Chinese.
If both of your input sources use the same keyboard layout, this step is not necessary.

## Setup

First, install [h-hg/fcitx.vim](https://github.com/h-hg/fcitx.nvim) in your Neovim setup (if you are using classical Vim, there are analogous extensions compatible with Vim as well).
Ensure that you have two input sources activated for your user.
The remainder of this section assumes Traditional Chinese Zhuyin and US keyboard.

Then, you need to set some environment variables in your shell configuration file.
Below is an example configuration:

```shell
# fcitx.nvim relies on this to work
export DISPLAY=fake

# Zhuyin - Traditional
export FCITX_NON_LATIN_ID="com.apple.inputmethod.TCIM.Zhuyin"

# U.S.
export FCITX_LATIN_ID="com.apple.keylayout.US"

# Ensure ~/bin is in your PATH
export PATH="$HOME/bin:$PATH"

# This is only necessary if your main keyboard layout is not QWERTY-based
# export FCITX_INTERMEDIATE_ID="com.apple.keylayout.US"
```

Compile the program:

```shell
$ make build
```

If you run the program now, it should output a `1` if you are in Latin state or `2` if you are in non-Latin state:

```shell
$ ./fcitx-remote
1
```

If any of the required environment variables is not set correctly, the program will print an error message and exit with a non-zero exit code:

```shell
$ ./fcitx-remote
FATAL: The environment variable FCITX_NON_LATIN_ID is not set!
This variable must be set to the ID of your non-Latin input method.
$ echo $?
1
```

If you run `./fcitx-remote -c`, it should switch your input source to your non-Latin input method.
If you run `./fcitx-remote -x`, it should switch back to the Latin input method.

Now, if you have configured the environment variables correctly, this command will install the binary to `~/bin`:

```shell
$ make install
```

Ensure that `fcitx-remote` is executable:

```shell
$ which fcitx-remote
/Users/karol/bin/fcitx-remote
```

When you start a new Neovim session, the program should work!
