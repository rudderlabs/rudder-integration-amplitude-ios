//
//  RudderAmplitudeIntegration.h
//  Rudder-Amplitude
//
//  Created by Desu Sai Venkat on 04/12/20.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>
@import Amplitude;

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

@property (nonatomic, strong) NSString *residencyServer;

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

