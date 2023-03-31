//
//  RudderAmplitudeIntegration.h
//  Rudder-Amplitude
//
//  Created by Desu Sai Venkat on 04/12/20.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>

NS_ASSUME_NONNULL_BEGIN

@interface AmplitudeIngestionMetadata : NSObject

@property (nonatomic, strong) NSString *sourceName;
@property (nonatomic, strong) NSString *sourceVersion;

@end

@interface AmplitudePlan : NSObject

@property (nonatomic, copy) NSString *branch;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *versionId;

@end

@interface AmplitudeConfig : NSObject
    
@property NSString *apiKey;

@property (nonatomic) int eventUploadPeriodMillis;
@property (nonatomic) int eventUploadThreshold;

@property (nonatomic) BOOL sendEvents;
@property (nonatomic) BOOL enableLocationListening;
@property (nonatomic) BOOL useIdfaAsDeviceId;
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
@property (nonatomic, nullable) AmplitudePlan *plan;
@property (nonatomic, nullable) AmplitudeIngestionMetadata *ingestionMetadata;
@property (nonatomic, strong) NSNumber *useAppSetIdForDeviceId; // Note: Boolean is not a primitive type in Objective-C
@property (nonatomic, strong) NSNumber *deviceIdPerInstall; // Note: Boolean is not a primitive type in Objective-C
@property (nonatomic, strong) NSNumber *enableCoppaControl; // Note: Boolean is not a primitive type in Objective-C
@property (nonatomic, strong) NSNumber *flushEventsOnClose; // Note: Boolean is not a primitive type in Objective-C
@property (nonatomic, strong) NSNumber *minTimeBetweenSessionMillis; // Note: Long is not a primitive type in Objective-C
@property (nonatomic, strong) NSNumber *identifyBatchIntervalMillis; // Note: Long is not a primitive type in Objective-C
@property (nonatomic, strong) NSNumber *flushMaxRetries; // Note: Integer is not a primitive type in Objective-C
@property (nonatomic, strong) NSNumber *optOut; // Note: Boolean is not a primitive type in Objective-C
@property (nonatomic, assign) BOOL useBatch;


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

