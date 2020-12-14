# What is Rudder?

**Short answer:**
Rudder is an open-source Segment alternative written in Go, built for the enterprise. .

**Long answer:**
Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.

Released under [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)

## Getting Started with Amplitude Integration of iOS SDK
1. Add [Amplitude](https://amplitude.com) as a destination in the [Dashboard](https://app.rudderstack.com/) and define all the fields.


3. Rudder-Amplitude is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Rudder-Amplitude'
```

## Initialize ```RudderClient```
Put this code in your `AppDelegate.m` file under the method `didFinishLaunchingWithOptions`
```XCode
RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
[builder withDataPlaneUrl:DATA_PLANE_URL];
[builder withFactory:[RudderAmplitudeFactory instance]];
[RSClient getInstance:WRITE_KEY config:[builder build]];
```

Add the below logic just after initalizing ```RudderClient``` in ```AppDelegate.m``` if you would like to send ```IDFA``` of ```iOS device``` as device id to Amplitude
```XCode
[Amplitude instance].adSupportBlock = ^{
return [[ASIdentifierManager sharedManager] advertisingIdentifier];
};
```

and then add the below logic if you would like to ```track location``` (latitude, longitude)
```XCode
[Amplitude instance].locationInfoBlock = ^{
        return @{
                  @"lat" : @37.7,
                  @"lng" : @122.4
                };
};
```

## Send Events
Follow the steps from [Rudder iOS SDK](https://github.com/rudderlabs/rudder-sdk-ios)

## Contact Us
If you come across any issues while configuring or using RudderStack, please feel free to [contact us](https://rudderstack.com/contact/) or start a conversation on our [Slack](https://resources.rudderstack.com/join-rudderstack-slack) channel. We will be happy to help you.
