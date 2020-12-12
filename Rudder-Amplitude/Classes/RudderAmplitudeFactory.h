//
//  RudderAmplitudeFactory.h
//  Rudder-Amplitude
//
//  Created by Desu Sai Venkat on 04/12/20.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>

NS_ASSUME_NONNULL_BEGIN

@interface RudderAmplitudeFactory : NSObject<RSIntegrationFactory>
+ (instancetype) instance;
@end

NS_ASSUME_NONNULL_END
