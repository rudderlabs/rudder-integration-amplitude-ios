//
//  RudderAmplitudeIntegration.h
//  Rudder-Amplitude
//
//  Created by Desu Sai Venkat on 04/12/20.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>

NS_ASSUME_NONNULL_BEGIN

@interface RudderAmplitudeIntegration : NSObject<RSIntegration>

@property (nonatomic) NSString *apiKey;

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


@property (nonatomic) NSSet *traitsToIncrement;
@property (nonatomic) NSSet *traitsToSetOnce;
@property (nonatomic) NSSet *traitsToAppend;
@property (nonatomic) NSSet *traitsToPrepend;

- (instancetype)initWithConfig:(NSDictionary *)config withAnalytics:(RSClient *)client withRudderConfig:(RSConfig*) rudderConfig;

@end

NS_ASSUME_NONNULL_END
