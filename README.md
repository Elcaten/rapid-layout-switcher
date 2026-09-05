# Rapid Layout Switcher

Rapid Layout Switcher is a small macOS menu-bar app for switching keyboard layouts by tapping a modifier key by itself.

Assign one layout to a left-side modifier and another layout to a right-side modifier. For example:

- Tap left Command to switch to ABC.
- Tap right Command to switch to Russian.
- Regular keyboard shortcuts continue to work normally.

![Rapid Layout Switcher settings](screenshots/SCR-20260905-mlev.png)

## First launch on macOS

Rapid Layout Switcher is built with a free Apple developer account and cannot be notarized. Because of this, macOS displays a security warning the first time you open the app.

1. Open Rapid Layout Switcher. When the security warning appears, click **Done**.

   ![macOS warning that Rapid Layout Switcher could not be verified](screenshots/SCR-20260905-nuhq.png)

2. Open **System Settings → Privacy & Security**, scroll to **Security**, and click **Open Anyway** next to the message about Rapid Layout Switcher.

   ![Open Anyway button for Rapid Layout Switcher in macOS Privacy and Security settings](screenshots/SCR-20260905-nrbb.png)

3. Confirm **Open** when prompted. Only bypass this warning for an app downloaded from the [official releases page](https://github.com/Elcaten/rapid-layout-switcher/releases).

## Getting started

1. Allow **Input Monitoring** when macOS asks. This permission is required to detect standalone modifier-key taps.
2. Choose a triggering key and keyboard layout for each side.
3. Close the settings window. The app continues running in the menu bar.

The available layout menus use the input sources currently enabled in **System Settings → Keyboard → Text Input**.

## Menu-bar indicator

The menu-bar badge always shows the language code for the current input source, such as `EN` or `RU`. Enable **Show input source name next to language code** if you also want the layout name displayed.

Open the menu-bar item to change that option, reopen Settings, enable **Start at Login**, or quit the app.

![Rapid Layout Switcher menu](screenshots/SCR-20260905-mmrl.png)

## Privacy

Rapid Layout Switcher uses a listen-only keyboard event monitor. It does not modify or generate keyboard events, execute scripts, or require Accessibility permission.
