<p align="center">
  <img src="https://github.com/jschiefner/shopping-list-ios/blob/main/photoshop/icon.png?raw=true" width="200" alt="Shopping List Icon">
</p>

## Shopping List iOS App

This app allows me to keep tracks of my shopping list. Items are split in categories which allow me to display items by section in the order i would pass them in a supermarket so i dont have to run around finding stuff from the list i missed earlier on. Items are sorted in categories automatically, assuming there has been a one-time assignment made for that item.

This is a cleaner reimplementation of the [Android version](https://github.com/jschiefner/shopping-list-android) of the app. The User Interface is implemented with SwiftUI.

<p align="center">
  <img src="https://github.com/jschiefner/shopping-list-ios/blob/main/photoshop/screenshot_shopping_list.png?raw=true" width="350" alt="Shopping List Icon">
  <img src="https://github.com/jschiefner/shopping-list-ios/blob/main/photoshop/screenshot_item_add.png?raw=true" width="350" alt="Shopping List Icon">
</p>

#### Get it up and running

This app uses the Google Cloud Firstore Database to keep in sync with all participating devices. In order to use it you have to:

1. Create a Firebase project at the [Firebase Console](https://console.firebase.google.com)
2. Download the `google-services.json` file and put in the `/shopping-list-ios` directory
3. Install [CocoaPods](https://cocoapods.org/) and run `$ pod install`
4. Open the `shopping-list-ios.xcworkspace` file in XCode and run the project
