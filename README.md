# AlertFilterSafariExtension
Safari App Extension to filter out "Do you want to allow this page to open ..." alert.

## Install
Please unzip and move AlertFilterSafariExtension.app to folder */Applications* on the Mac.
Open the app will install the embeded extension to Safari.

As the release is unsigned extension, you will need to let Safari allow it first to show it in the Extensions tab in Safari.

Please check this page to get more information on how to enable "allow unsigned extension" in Safari:
https://developer.apple.com/library/content/documentation/NetworkingInternetWeb/Conceptual/SafariAppExtension_PG/CreatingandTestingYourFirstSafariAppExtension.html#//apple_ref/doc/uid/TP40017319-CH11-SW1

## Usage
Click the AlertFilter button on Safari toolbar, you could add a custom scheme by clicking the plus button. Then reload current opened pages to apply the configuration change.

> For example, if you have Github Desktop app installed on your Mac, and add the scheme "github-mac" to the Scheme List.
> When you click the button "Open in Desktop" to clone a repository via the app, AlertFilter will handle the click and filter out the Safari security alert. The Github Desktop will opened directly without the alert popup.
