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

@implementation _AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSString *WRITE_KEY = @"1lBKwrWfz3uxVlqwhILguTz8XGL";
    NSString *DATA_PLANE_URL = @"http://localhost:8080";
    
    RSConfigBuilder *configBuilder = [[RSConfigBuilder alloc] init];
    [configBuilder withDataPlaneUrl:DATA_PLANE_URL];
    [configBuilder withControlPlaneUrl:@"https://afec5af4ff10.ngrok.io"];
    [configBuilder withLoglevel:RSLogLevelDebug];
    [configBuilder withFactory:[RudderAmplitudeFactory instance]];
    [RSClient getInstance:WRITE_KEY config:[configBuilder build]];
    
    // identify call
    NSMutableArray *awardsArray = [NSMutableArray array];
    [awardsArray addObject:[NSNumber numberWithInt:5]];
    [awardsArray addObject:[NSNumber numberWithInt:6]];
    NSMutableArray *rewardsArray = [NSMutableArray array];
    [rewardsArray addObject:[NSNumber numberWithInt:7]];
    [rewardsArray addObject:[NSNumber numberWithInt:8]];
    
    [[RSClient sharedInstance] identify:@"hithendra"
                                 traits:@{@"firstName": @"Manchana",
                                          @"LastName": @"Hithendra"
//                                          @"email": @"hithu@gmail.com",
//                                          @"friends":[NSNumber numberWithInt:40],
//                                          @"city":@"hyderabad",
//                                          @"awards":awardsArray,
//                                          @"rewards":rewardsArray
                                 }];
    // screen call
//    [[RSClient sharedInstance] screen:@"AMB Cinemas"  properties:@{@"prop_key" : @"prop_value",@"category":@"Maari"}];
    // Track Call
       [[RSClient sharedInstance] track:@"simple_track_event"];
        [[RSClient sharedInstance] track:@"simple_track_with_props" properties:@{
            @"key_1" : @"value_1",
            @"key_2" : @"value_2"
        }];
        //Group Call
        // same problem as in android
        [[RSClient sharedInstance] group:@"sample_group_id"
                                  traits:@{@"foo": @"bar",
                                           @"foo1": @"bar1",
                                           @"email": @"test@gmail.com"}
         ];
    //    //Reset Call
    //    [[RSClient sharedInstance] reset];
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
