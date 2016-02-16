Geoloqi SDK
===========

Also see our [Getting Started Guide](https://developers.geoloqi.com/ios/getting-started) on our developer website.


Sample App
----------

The Sample iPhone app project will get you started quickly using the SDK. When you open the Xcode project, all you need to do is fill in your API key in `LQConfig.h`, which you can get from our [developer site](https://developers.geoloqi.com/get-an-api-key).

![API Key and Secret](https://developer-site-content.geoloqi.com/wiki/images/thumb/0/06/TrackerSample_set_your_api_key_and_secret.png/670px-TrackerSample_set_your_api_key_and_secret.png)

After you build the project, you should see the sample app in the simulator.

![TrackerSample App](https://developer-site-content.geoloqi.com/wiki/images/thumb/1/1f/TrackerSample_iPhone_App.png/280px-TrackerSample_iPhone_App.png)

You can choose the "passive" mode to start tracking in background mode which will conserve as much battery power as possible.

If you choose "logging" mode, you will record much more data and it will be sent to the server in batches. 

After the phone or simulator has located its position, you can press the "Get Location" button which will make an API request to the Geoloqi API and retrieve information about the current location.


Adding the SDK to an existing project
-------------------------------------

If you are adding the SDK to an existing project, follow the steps in our [Getting Started guide](https://developers.geoloqi.com/ios/getting-started).

You will need to:

* Add the library to your project
* Set up your app delegate to notify the SDK when your app launches
* Handle push notification registration if needed
* Choose a tracking mode to get started

