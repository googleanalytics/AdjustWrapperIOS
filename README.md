# Google Analytics for Firebase Wrapper for Adjust

_Copyright (c) 2019 Google Inc. All rights reserved._

The __Google Analytics for Firebase__ wrapper for Adjust allows developers to
easily send information to both the Adjust and Google Analytics for Firebase
backends.

## Using the Wrapper

In order to use the Adjust wrapper:

1.  [Follow the steps here](https://firebase.google.com/docs/analytics/ios/start)
    to set up the Google Analytics for Firebase SDK in your app.
2.  Copy the source files inside the AdjustWrapper directory into your project.
3.  Register your Adjust token to event dictionary mapping using `[AdjustWrapper
    setEventMapping:]` after Firebase initialization. This mapping allows the
    wrapper to log events to the Google Analytics SDK with the real name (not
    just the token).
4.  Replace supported references to `Adjust` API with `AdjustWrapper`;
5.  Replace references to `ADJEvent` with `ADJWrappedEvent`.

Some methods are not supported by the wrapper. For these methods, directly call
the base implementation on the `Adjust` object.

### Registering the Event Mapping

Instead of using event names within the SDK, Adjust uses tokens that map to
event names on the backend. Since the Google Analytics for Firebase SDK is
unaware of this mapping, it should be provided to the wrapper to ensure that the
event names show up properly in the Firebase console. Register it by passing a
dictionary into the `[AdjustWrapper setEventMapping:]` API. This dictionary
should reflect the token to event name mapping provided by Adjust. Make sure
that this mapping is established before the first Adjust event is logged, or
event name shown in the Firebase console will be incorrect.

Example:

```
[AdjustWrapper setEventMapping: @{
  @"abcde1" : @"sign_up",
  @"abcde2" : @"tutorial_begin",
  @"fghijk" : @"your_custom_event"
}];
```

### Supported Methods

The following API methods and properties are supported in the AppsFlyer wrapper.
Use the wrapper by replacing `Adjust` in these instances with `AdjustWrapper`:

*   `[[Adjust sharedTracker] trackEvent:]`
*   `[Adjust trackEvent: withValue:]`

Replace `ADJEvent` with `ADJWrappedEvent` in these instances:

*   `[ADJEvent eventWithEventToken:]`
*   `[ADJEvent alloc] initWithEventToken:]`

### Using With Swift

In order to use the Adjust wrapper with a Swift project, make sure your project
has a
[bridging header](https://developer.apple.com/documentation/swift/imported_c_and_objective-c_apis/importing_objective-c_into_swift).
In the bridging header file, add the line `#import "AdjustWrapper.h"`. This will
allow you to use AdjustWrapper like a normal Swift class.
