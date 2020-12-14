//
//  RudderAmplitudeFactory.m
//  Rudder-Amplitude
//
//  Created by Desu Sai Venkat on 04/12/20.
//

#import "RudderAmplitudeFactory.h"
#import "RudderAmplitudeIntegration.h"

@implementation RudderAmplitudeFactory
static RudderAmplitudeFactory *sharedInstance;

+ (instancetype)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (nonnull NSString *)key
{
    return @"Amplitude";
}


- (id<RSIntegration>)initiate:(NSDictionary *)config client:(RSClient *)client rudderConfig:(nonnull RSConfig *)rudderConfig
{
    [RSLogger logDebug:@"Creating RudderIntegrationFactory: Amplitude"];
    return [[RudderAmplitudeIntegration alloc] initWithConfig:config
                                                withAnalytics:client
                                             withRudderConfig:rudderConfig];
}
@end
