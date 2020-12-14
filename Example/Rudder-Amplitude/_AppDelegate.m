//
//  _AppDelegate.m
//  Rudder-Amplitude
//
//  Created by Arnab on 11/18/2020.
//  Copyright (c) 2020 Arnab. All rights reserved.
//

#import "_AppDelegate.h"
#import <Rudder/Rudder.h>
#import "RudderAmplitudeFactory.h"
#import <Amplitude/Amplitude.h>

@implementation _AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSString *WRITE_KEY = @"1ilteYA7Ws2JJyqYcoj2LRpp73J";
    NSString *DATA_PLANE_URL = @"http://localhost:8080";
    
    RSConfigBuilder *configBuilder = [[RSConfigBuilder alloc] init];
    [configBuilder withDataPlaneUrl:DATA_PLANE_URL];
    [configBuilder withControlPlaneUrl:@"https://api.dev.rudderlabs.com"];
    [configBuilder withLoglevel:RSLogLevelDebug];
    [configBuilder withFactory:[RudderAmplitudeFactory instance]];
    [RSClient getInstance:WRITE_KEY config:[configBuilder build]];
    
    //Optional : Uncomment this to enable Tracking Location
//    [Amplitude instance].locationInfoBlock = ^{
//        return @{
//                  @"lat" : @37.7,
//                  @"lng" : @122.4
//                };
//      };
//    //Optional : Uncomment this to send IDFA as device ID to Amplitude
//      [Amplitude instance].adSupportBlock = ^{
//        return @"49e1ba7f-ad0a-4cf4-b7a7-393d000fa192";
//      };
    
    // identify call
    NSMutableArray *awardsArray = [NSMutableArray array];
    [awardsArray addObject:[NSNumber numberWithInt:5]];
    [awardsArray addObject:[NSNumber numberWithInt:6]];
    NSMutableArray *rewardsArray = [NSMutableArray array];
    [rewardsArray addObject:[NSNumber numberWithInt:7]];
    [rewardsArray addObject:[NSNumber numberWithInt:8]];
    
//    [[RSClient sharedInstance] identify:@"JamesBond"
//                                 traits:@{@"firstName": @"James",
//                                          @"LastName": @"Bond",
//                                          @"email": @"Bond@james.com",
//                                          @"friends":[NSNumber numberWithInt:10],
//                                          @"city":@"CA",
//                                          @"awards":[NSNumber numberWithInt:1],
//                                          @"rewards":@"11"
//                                 }];
    // screen call
//    [[RSClient sharedInstance] screen:@"The Cinema"  properties:@{@"prop_key" : @"prop_value",@"category":@"TENET"}];
    // Track Call
    //[[RSClient sharedInstance] track:@"simple_track_event"];
//    [[RSClient sharedInstance] track:@"simple_track_with_props" properties:@{
//        @"key_1" : @"value_1",
//        @"key_2" : @"value_2"
//    }];
//    [[RSClient sharedInstance] track:@"Order Done" properties:@{
//        @"revenue" : @100,
//        @"orderId" : @"ooo1111111",
//        @"products" : @[
//                @{
//                    @"productId" : @"12##89",
//                    @"price" : @12,
//                    @"quantity" : @1
//                },
//                @{
//                    @"productId" : @"8900",
//                    @"price" : @21,
//                    @"quantity" : @3
//                }
//        ]
//    }];
//    //Group Call
//    // same problem as in android
//    [[RSClient sharedInstance] group:@"group_id"
//                              traits:@{@"company_id": @"RS",
//                                       @"company_name": @"RudderStack"}
//     ];
//    //    //Reset Call
//    [[RSClient sharedInstance] reset];
    
//    [[RSClient sharedInstance] identify:@"Varoon_Sood"
//    traits:@{@"firstName": @"Varun",
//             @"LastName": @"Sood",
//             @"email": @"varun@hotmail.com",
//             @"age" : @28
//    }];
    
    //increemnet
//    [[RSClient sharedInstance] identify:@"1111111"
//                                     traits:@{@"firstName": @"Desu",
//                                              @"LastName": @"Venkat",
//                                              @"email": @"desu@hotmail.com",
//                                              @"age" : @32,
//                                              @"Karma": @2,
//                                              @"freinds": @"123"
//                                     }];

//    [[RSClient sharedInstance] identify:@"ID_444"
//                                     traits:@{@"firstName": @"Nisha",
//                                              @"LastName": @"Mazumder",
//                                              @"email": @"nishhahhaah@hotmail.com",
//                                              @"age" : @2,
//                                              @"Karma": @20
//                                     }];

    
    //append
    //NSArray *objCArray = [NSArray arrayWithObjects:@"10", @"20", nil];
//    [[RSClient sharedInstance] identify:@"1111111"
//                                 traits:@{@"sign-up": @"2018-01-01"
//                                     }];

//    //prepend
//    NSArray *objCArray1 = [NSArray arrayWithObjects:@"10", @"20", nil];
//    [[RSClient sharedInstance] identify:@"ID_5555"
//                                    traits:@{@"firstName": @"MS.",
//                                             @"LastName": @"Saha",
//                                             @"email": @"Rina@hotmail.com",
//                                             @"some_anothe_rlist": objCArray1
//                                    }];

//    [[RSClient sharedInstance] group:@"group222222"
//                             traits:@{@"AMname": @"name of amplitude",
//                                      @"AMvalue": @"value of amplitude",
//                                      @"email": @"testoo@gmail.com"}
//    ];

//    [[RSClient sharedInstance] identify:@"Varoon_Sood"];
//    [[RSClient sharedInstance] track:@"Before reset()"];
//
        
//    [[RSClient sharedInstance] identify:@"Id000000"
//                                         traits:@{@"firstName": @"DEVELOP",
//                                                  @"LastName": @"Saha",
//                                                  @"email": @"mainak@hotmail.com",
//                                                  @"age" : @27,
//                                                  @"Karma": @100
//                                         }];
    
    
   
    
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
