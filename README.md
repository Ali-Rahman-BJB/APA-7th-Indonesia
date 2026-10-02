# APA 7th Edition Indonesia for Microsoft Word

A citation style for the **APA 7th edition (Indonesian version)** for Microsoft Word. Once installed, the style appears in Word as **"APA7 Indonesia"** under *References > Style*.

This repository is owned and maintained by **Ali Rahman**. It is a fork of [APA-7th-Edition](https://github.com/briankavanaugh/APA-7th-Edition) by Brian Kavanaugh, adapted for Indonesian users.

## About This Repository

- **Owner & maintainer:** Ali Rahman
- **Fork source:** [briankavanaugh/APA-7th-Edition](https://github.com/briankavanaugh/APA-7th-Edition) (Copyright (c) 2021 Brian Kavanaugh)
- **XSLT file basis:** APA 7th Edition XSLT as modified by Mike Slagle, plus two fixes taken from comments on [this Microsoft Answers forum thread](https://answers.microsoft.com/en-us/msoffice/forum/all/apa-7th-edition-in-ms-word/486fc70e-b7c7-40df-89bb-f8fc07169d40)
- **Changes in this repository:**
  - The citation style is named **"APA7 Indonesia"**
  - The installer scripts (`.bat` for Windows and `.sh` for macOS) are in Indonesian
  - The scripts install the **local** `.xsl` file in the same folder instead of downloading it from the internet
  - The macOS script validates the XML before installing and supports the `--persist` option

> **Important:** This style file is provided as an aid for anyone who needs a better APA 7 option than the one built into Microsoft Word. The original XSLT template was **not** created by me. If you run into problems, please fix them (where possible; there are limits to what XSLT can do in Word) and submit a pull request.

## Usage

### Windows

#### Manual method

1. Close Word.
2. Copy the `APASeventhEdition.xsl` file to this folder:
   `C:\Users\<username>\AppData\Roaming\Microsoft\Bibliography\Style`
3. Reopen Word, then on the **References** tab select the **APA7 Indonesia** style.

#### `.bat` file method

1. Close Word.
2. Place `APASeventhEdition.bat` **in the same folder** as `APASeventhEdition.xsl`, then double-click it.
3. Reopen Word, then on the **References** tab select the **APA7 Indonesia** style.

Note: the `.bat` file copies `APASeventhEdition.xsl` from the same folder to `%appdata%\Microsoft\Bibliography\Style`. Nothing is downloaded from the internet.

### macOS

#### Manual method

1. Close Word.
2. Using Finder, copy `APASeventhEdition.xsl` to **two** locations:
   1. `HD/Applications/Microsoft Word.app/Contents/Resources/Style/` (right-click the app icon, then choose "Show Package Contents")
   2. `HD/Users/<username>/Library/Containers/com.microsoft.Word/Data/Library/Application Support/Microsoft/Office/Style/`
3. Reopen Word, then on the **References** tab select the **APA7 Indonesia** style.

#### Terminal script method

* **This script requests administrator privileges using `sudo`. Only run files that you trust and understand.**

1. Fully close Word.
2. Place `APASeventhEdition.sh` **in the same folder** as `APASeventhEdition.xsl`.
3. Open Terminal (find it via Spotlight).
4. Go to that folder: `cd /path/to/folder`
5. Run the script:
   1. `bash APASeventhEdition.sh`
   2. Enter your password when prompted. The screen shows nothing as you type; press Enter when you are done.
   3. The file will be copied to both Word locations.
   4. *Optional:* run with the `--persist` option so the file is automatically reinstalled on reboot or after Word is updated (this works around Microsoft AutoUpdate deleting the file): `bash APASeventhEdition.sh --persist`

Notes:

* The script keeps a local copy in `/Library/Application Support/APAStyleTool`, then copies it to the two Word folders.
* If Terminal fails to copy into `Microsoft Word.app`, grant permission under *System Settings > Privacy & Security > App Management* (or *Full Disk Access*), then try again.
* The `--persist` option creates a LaunchDaemon that runs at boot with *root* privileges and monitors Word's `Info.plist`. **Always read the script before running it.**
* To remove the LaunchDaemon:
  `sudo launchctl bootout system /Library/LaunchDaemons/com.apastyle.copy.plist && sudo rm /Library/LaunchDaemons/com.apastyle.copy.plist "/Library/Application Support/APAStyleTool/apply.sh"`
* Log: `tail -f /var/log/apastylecopy.log`

## Contributing

Suggestions, issue reports, and pull requests are very welcome. Because of the limitations of XSLT in Word, not every APA 7 rule can be implemented perfectly.

## Credits

- **Brian Kavanaugh**, creator of the original repository (Copyright (c) 2021 Brian Kavanaugh)
- **Mike Slagle**, modifications to the APA 7th Edition XSLT
- Commenters on the Microsoft Answers forum for two additional fixes
- **Ali Rahman**, owner and maintainer of this APA 7th Indonesia repository

## License

This repository follows the license of the original repository. See the `LICENSE` file for details; the original copyright remains in the name of Brian Kavanaugh.

## Disclaimer

These files are provided for educational purposes only, along with their placement locations. If your Microsoft Office installation is damaged as a result of using these files, I am not responsible for fixing the problem.