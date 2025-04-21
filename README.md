<img src="https://github.caffeine-app.net/assets/icon.png" alt="Icon" width="239"/>

# Caffeine Lite

### Don't let your Mac fall asleep.

Caffeine Lite is a tiny program that keeps your Mac awake, useful for ensuring that long running tasks aren't interrupted by your computer going to sleep.

It's a simplification of the application Caffeine originally by Lighthead Software, then IntelliScape Computer Solutions, and now currently maintained by Dominic Rodemer and found at [https://caffeine-app.net](https://caffeine-app.net). Rather than remaining active with an icon in the menu bar as Caffeine and many similar applications do, Caffeine Lite is intended to be launched manually when disabling sleep is needed infrequently. It opens its window when launched with a button to start disabling sleep, and stops disabling sleep automatically when it quits upon closing the window.

### Installation

Download Caffeine Lite at https://github.com/jpmhouston/Caffeine-Lite/releases and drag it into your Applications folder, then double-click the icon to launch it when needed.

### Usage

Caffeine Lite opens its settings window when you launch it, with a button to starting disabling sleep, pressing it again enabled sleep again as does closing the window which quits the application. Options you can configure include whether Caffeine Lite should activate automatically when time it starts, and a default duration if you always want Caffeine Lite to turn itself off after a set time.

<img src="https://raw.githubusercontent.com/jpmhouston/Caffeine-Lite/refs/heads/master/assets/preferences.png" alt="Preferences" width="469"/>

### FAQ

##### Is this the same Caffeine that I've used before?

Yes! Tomas Franzén of Lighthead Software originally developed Caffeine in 2006, and it has been a well known and loved utility for Mac users for many years. Its simplicity has allowed it to continue working perfectly long after active development had ceased.

In 2018, Michael Jones (IntelliScape Computer Solutions) reached out to Tomas to inquire if they could continue development of Caffeine.

Tomas has graciously provided the source code under an open source license, allowing IntelliScape Computer Solutions to continue developing Caffeine where he left off.

The upstream source this repo forked from is a continuation of that project by Dominic Rodemer, and I, Pierre Houston at Bananameter Labs, got his kind permission to fork it once more to make my simplification changes for when disabling sleep is needed only infrequently.

##### Does this work with macOS 10.x?

No, this version requires at least macOS 11 (Big Sur). Caffeine for macOS Yosemite or later (including Catalina) is available at: https://www.intelliscapesolutions.com/apps/caffeine/

##### How is Caffeine Lite different or better than alternatives (such as the original Caffeine, Amphetamine, KeepingYouAwake, etc)?

Due to the long period of inactivity for the original Caffeine, a lot of different and great options have been developed. While the alternatives are great apps and definitely worth your consideration, we believe that Caffeine's power lies in its simplicity and ease of use, which Caffeine Lite simplifies even further when needed for only infrequent use.

### Localization Help Needed

The upstream project [Caffeine](https://github.com/domzilla/Caffeine) is translated to 12 language (English, German, Dutch, French, Italian, Spanish, Russian, Portuguese, Brazilian Portuguese, Japanese, Korean, Simplified Chinese). These UI changes I made need to be localized:

- menu: "Activate"

- menu item: "Deactivate"

- preferences window text: "Caffeine Lite is running but not yet activated. Click the Prevent Sleep button below to disable automatic sleep, click it again to enable automatic sleep."

- preferences window text: "Caffeine Lite is running and activated, automatic sleep is disabled. To enable automatic sleep according to System Settimgs, click the Permit Sleep button below or close this window to quit."

- preferences window button: "Prevent Sleep"

- preferences window button: "Permit Sleep"

These menu items might or might not get translated by macOS and need to be translated they aren't:

- the application menu item: "Hide Caffeine Lite"

- the help menu item: "Caffeine Lite Help"

Plus these edits I made to the English-spelled application name in all languages, changing "Caffeine" to "Caffeine Lite", should corrected if necessary:

- the application menu's About menu item

- the application menu's Quit menu item

- the preferences window title

### Support

If you have questions, comments or other feedback get in touch at https://bananameter.lol