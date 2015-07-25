This app is an example app that allows the user to search Twitter by text or by location. Searches by location in the map view can also be filtered by a given search term.

# Getting the app running

Note that this app requires access to a Twitter account stored on the iOS device. Before trying to run the app on device or in the simulator, make sure you have a valid Twitter account set up in the Settings app.

Install the project's dependencies with [Cocoapods](https://cocoapods.org/) using 
```
pod install
```

Open the generated `TwitterDemo.xcworkspace` and run the `TwitterDemo` scheme.

# Using the app

You can search for tweets containing a specific search term in the "Search" tab.

Tweets can also be found by location in the "Map" tab. Center the map on the geographic region that you want to find tweets in, and tap the "Find Tweets" button. You can also search for tweets with a particular search term in a given geographical region with the Map view.