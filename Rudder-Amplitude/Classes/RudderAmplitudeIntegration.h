//
//  RudderAmplitudeIntegration.h
//  Rudder-Amplitude
//
//  Created by Desu Sai Venkat on 04/12/20.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>
#import <Amplitude/AMPPlan.h>
#import <Amplitude/AMPIngestionMetadata.h>
#import <Amplitude/AMPTrackingOptions.h>

NS_ASSUME_NONNULL_BEGIN



@interface AmplitudeConfig : NSObject
    
@property NSString *apiKey;

@property (nonatomic) int eventUploadPeriodMillis;
@property (nonatomic) int eventUploadThreshold;

@property (nonatomic) BOOL trackSessionEvents;

@property (nonatomic) BOOL trackAllPages;
@property (nonatomic) BOOL trackNamedPages;
@property (nonatomic) BOOL trackCategorizedPages;

@property (nonatomic) BOOL trackProductsOnce;
@property (nonatomic) BOOL trackRevenuePerProduct;

@property (nonatomic) NSString *groupTypeTrait;
@property (nonatomic) NSString *groupValueTrait;

@property (nonatomic, assign) BOOL useAdvertisingIdForDeviceId;
@property (nonatomic, strong) NSString *residencyServer;
@property (nonatomic, strong) NSString *serverUrl;
@property (nonatomic, nullable) AMPPlan *plan;
@property (nonatomic, nullable) AMPIngestionMetadata *ingestionMetadata;
@property (nonatomic, nullable) AMPTrackingOptions *trackingOptions;
@property (nonatomic, assign) BOOL *enableCoppaControl; //default false
@property (nonatomic) int minTimeBetweenSessionMillis; // defult 5 minutes
//setIdentifyUploadPeriodSeconds for iOS
@property (nonatomic) int identifyBatchIntervalMillis;
@property (nonatomic, assign) BOOL *optOut;
//specific to iOS
@property (nonatomic) int eventUploadMaxBatchSize; //The maximum number of events sent with each upload request. default - 100
@property (nonatomic) int eventMaxCount; //The maximum number of unsent events to keep on the device. default 1000
@property (nonatomic, assign) BOOL *offline; //Disables sending logged events to Amplitude servers. Events will be sent when set to true.
@property (nonatomic) int identifyUploadPeriodSeconds;//The amount of time SDK will attempt to batch intercepted identify events. default 30


@property (nonatomic) NSSet *traitsToIncrement;
@property (nonatomic) NSSet *traitsToSetOnce;
@property (nonatomic) NSSet *traitsToAppend;
@property (nonatomic) NSSet *traitsToPrepend;

@end

@interface RudderAmplitudeIntegration : NSObject<RSIntegration>{
    AmplitudeConfig *amplitudeConfig;
}

- (instancetype)initWithConfig:(NSDictionary *)config withAnalytics:(RSClient *)client withRudderConfig:(RSConfig*) rudderConfig;

@end


NS_ASSUME_NONNULL_END

