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
    NSString *DATA_PLANE_URL = @"https://c6e8be50761c.ngrok.io";
    
    RSConfigBuilder *configBuilder = [[RSConfigBuilder alloc] init];
    [configBuilder withDataPlaneUrl:DATA_PLANE_URL];
    [configBuilder withControlPlaneUrl:@"https://api.dev.rudderlabs.com"];
    [configBuilder withLoglevel:RSLogLevelDebug];
    [configBuilder withFactory:[RudderAmplitudeFactory instance]];
    [RSClient getInstance:WRITE_KEY config:[configBuilder build]];
    
   
    //TC:1. Track before identify

//    [[RSClient sharedInstance] track:@"simple_track_with_props" properties:@{
//            @"key_1" : @"value_1",
//            @"key_2" : @"value_2"
//        }];
//
//    //TC:2. Identify only with user id
//
//    [[RSClient sharedInstance] identify:@"User_111"];
//
//
//
//    //TC:3. Identify with the previous user id and new user properties
//
//    [[RSClient sharedInstance] identify:@"User_111"
//                                     traits:@{@"firstName": @"Daniel",
//                                              @"LastName": @"Smith",
//                                              @"email": @"smith@hotmail.com",
//                                              @"age" : @21
//                                     }];
//
//    //TC:4. Track after identify
//
//    [[RSClient sharedInstance] track:@"simple_track_event"];
//
//
//    //TC:5. Sending revenue event with revenue and without quantity
//
//    [[RSClient sharedInstance] track:@"Order Done" properties:@{
//            @"revenue" : @100,
//            @"orderId" : @"ooo1111111",
//            @"products" : @[
//                    @{
//                        @"productId" : @"12##89",
//                        @"price" : @12,
//                        @"quantity" : @1
//                    },
//                    @{
//                        @"productId" : @"8900",
//                        @"price" : @21,
//                        @"quantity" : @3
//                    }
//            ]
//        }];
//
//
//
//    //TC:6. Sending revenue event with revenue, quantity, products, receipt to check the verified revenue
//
//    [[RSClient sharedInstance] track:@"Item Purchased" properties:@{
//            @"revenue" : @20,
//            @"orderId" : @"ooo2222222",
//            @"quantity": @2,
//            @"receiptSignature": @"GST-INCLUDE",
//            @"products" : @[
//                    @{
//                        @"productId" : @"12##89",
//                        @"price" : @12,
//                        @"quantity" : @1
//                    },
//                    @{
//                        @"productId" : @"8900",
//                        @"price" : @21,
//                        @"quantity" : @3
//                    }
//            ]
//        }];
//
//    //TC:7. Sending revenue event with revenue as String/Integer/Empty
//
//    [[RSClient sharedInstance] track:@"Order Done 1" properties:@{
//            @"revenue" : @"12",
//            @"orderId" : @"ooo444444444",
//            @"products" : @[
//                    @{
//                        @"productId" : @"12##89",
//                        @"price" : @12,
//                        @"quantity" : @1
//                    },
//                    @{
//                        @"productId" : @"8900",
//                        @"price" : @21,
//                        @"quantity" : @3
//                    }
//            ]
//        }];
//
//    [[RSClient sharedInstance] track:@"Order Done 2" properties:@{
//            @"revenue" : @13.45,
//            @"orderId" : @"ooo444444444",
//            @"products" : @[
//                    @{
//                        @"productId" : @"12##89",
//                        @"price" : @12,
//                        @"quantity" : @1
//                    },
//                    @{
//                        @"productId" : @"8900",
//                        @"price" : @21,
//                        @"quantity" : @3
//                    }
//            ]
//        }];
//
//    [[RSClient sharedInstance] track:@"Order Done 3" properties:@{
//            @"revenue" : @"",
//            @"orderId" : @"ooo444444444",
//            @"products" : @[
//                    @{
//                        @"productId" : @"12##89",
//                        @"price" : @12,
//                        @"quantity" : @1
//                    },
//                    @{
//                        @"productId" : @"8900",
//                        @"price" : @21,
//                        @"quantity" : @3
//                    }
//            ]
//        }];
//
//    //TC:8. Sending revenue event with multiple products and for each product price/revenue and quantity by enabling "Track revenue per product"
//
//     [[RSClient sharedInstance] track:@"Shipping Done" properties:@{
//            @"revenue" : @24,
//            @"orderId" : @"ooo1111111",
//            @"products" : @[
//                    @{
//                        @"productId" : @"12345678",
//                        @"price" : @12,
//                        @"quantity" : @1
//                    },
//                    @{
//                        @"productId" : @"22334455",
//                        @"price" : @21,
//                        @"quantity" : @3
//                    }
//            ]
//        }];
//
//     [[RSClient sharedInstance] track:@"Shipping Done 2" properties:@{
//            @"revenue" : @24,
//            @"orderId" : @"ooo222222",
//            @"products" : @[
//                    @{
//                        @"productId" : @"12345678",
//                        @"revenue" : @10,
//                        @"quantity" : @1
//                    },
//                    @{
//                        @"productId" : @"22334455",
//                        @"revenue" : @20,
//                        @"quantity" : @3
//                    }
//            ]
//        }];
//
//
//    //**Sending revenue without products = revenue should be tracked
//
//     [[RSClient sharedInstance] track:@"Shipping Done 0000" properties:@{
//            @"revenue" : @24,
//            @"orderId" : @"ooo222222"}];
//
//
//    //TC:9. Sending revenue event with multiple products by enabling "Track product once"
//
//     [[RSClient sharedInstance] track:@"Shipping Done 11111" properties:@{
//                       @"revenue" : @24,
//                       @"orderId" : @"ooo222222",
//                       @"products" : @[
//                               @{
//                                   @"productId" : @"12345678",
//                                   @"revenue" : @10,
//                                   @"quantity" : @1
//                               },
//                               @{
//                                   @"productId" : @"22334455",
//                                   @"revenue" : @20,
//                                   @"quantity" : @3
//                               }
//                       ]
//     }];
//    //TC:10. Sending screen call with name, category by enabling only "Track name page"
//
//    [[RSClient sharedInstance] screen:@"The Cinema"];
//
//    //Or
//
//    [[RSClient sharedInstance] screen:@"Cinema Name"  properties:@{@"prop_key" : @"prop_value",@"category":@"TENET"}];
//
//
//    //TC:11. Sending screen call with name, category by enabling only "Track category page"
//
//     [[RSClient sharedInstance] screen:@"MainActivity"  properties:@{@"prop_key" : @"prop_value",@"category":@"TENET"}];
//
//
//    //TC:12. Sending screen call with name by enabling "Track all pages"
//
//    [[RSClient sharedInstance] screen:@"All Pages"];
//
//
//
//    //TC:13. Sending screen call without name by enabling "Track all pages"
//
//     [[RSClient sharedInstance] screen:@""];
//
//
//    //TC:14. Sending screen call without name by enabling "Track name pages"
//
//    [[RSClient sharedInstance] screen:@""];
//
//
//    //TC:15. Sending screen call with name, category by enabling "Track name page" and "Track category page"
//
//     [[RSClient sharedInstance] screen:@"Home Page"  properties:@{@"prop_key" : @"prop_value",@"category":@"Home Category"}];
//
//
//    //TC:16. Sending track event by enabling “Prefer advertisingId for device id” settings on dashboard

   //[[RSClient sharedInstance] track:@"simple_track_event"];
    //    //Optional : Uncomment this to send IDFA as device ID to Amplitude
    //      [Amplitude instance].adSupportBlock = ^{
    //        return @"49e1ba7f-ad0a-4cf4-b7a7-393d000fa192";
    //      };
        
//      GROUP TRAITS SET ON THE DASHBOARD - AMname, AMvalue
//    //TC:17. Sending group call with group properties by giving the trait value to "Group Type Trait" and "Group Value Trait"
//
//    [[RSClient sharedInstance] group:@"group11111"
//                                  traits:@{@"AMname": @"name of amplitude",
//                                           @"AMvalue": @"value of amplitude",
//                                           @"email": @"test@gmail.com"}
//         ];
//
//    //TC:18. Legacy group call behaviour check by not giving any trait value to "Group Type Trait" and "Group Value Trait"
//
//    [[RSClient sharedInstance] identify:@"JamesBond"
//                                     traits:@{@"firstName": @"James",
//                                              @"LastName": @"Bond",
//                                              @"email": @"Bond@james.com"
//                                     }];
//    [[RSClient sharedInstance] group:@"group11111"
//                                  traits:@{@"AMname": @"name of amplitude",
//                                           @"AMvalue": @"value of amplitude",
//                                           @"email": @"test@gmail.com"}
//         ];
//
//
//    //TC:19. Sending reset call
//
////        [[RSClient sharedInstance] identify:@"User_333"];
////        [[RSClient sharedInstance] track:@"Before reset()"];
//        //After creating a button add the below two function in _viewController.m file
////        - (IBAction)callReset:(id)sender {
////
////        [[RSClient sharedInstance] reset];
////    }
////
////    - (IBAction)callTrack:(id)sender {
////
////        [[RSClient sharedInstance] track:@"simple_track_with_props" properties:@{
////            @"key_1" : @"value_1",
////            @"key_2" : @"value_2"
////        }];
////    }
//
//
//    //TC:20. optOutSession check for user identify call and track event call
//
//    //Track call:
//
//     [[RSClient sharedInstance] track:@"1st track call"];
//     [[RSClient sharedInstance] track:@"2nd track call" properties:@{
//                @"key_1" : @"value_1",
//                @"optOutOfSession" : @YES
//        }];
//      [[RSClient sharedInstance] track:@"3rd track call"];
//

    //==>Identify: Even after optOutSession for identify call, we can see new session because “Application Opened” event is sent automatically and that is resulting in the session creation.

    //TC:21. Extra settings check:

    //a. Enable Location Listening

//     [[RSClient sharedInstance] identify:@"User_333"];
//        [[RSClient sharedInstance] track:@"User id 333 2nd event call" properties:@{
//                @"key_1" : @"value_1"
//        }];
    //Optional : Uncomment this to enable Tracking Location
    //    [Amplitude instance].locationInfoBlock = ^{
    //        return @{
    //                  @"lat" : @37.7,
    //                  @"lng" : @122.4
    //                };
    //      };
    

    //b. Traits to increment

//    [[RSClient sharedInstance] identify:@"User_444"
//                                     traits:@{@"firstName": @"Nisha",
//                                              @"LastName": @"Mazumder",
//                                              @"email": @"nishu@hotmail.com",
//                                              @"age" : @32,
//                                              @"Karma": @1,
//                                              @"freinds": @"Amr"
//                                     }];
//
//    //Traits set - Karma, friends
//
//    [[RSClient sharedInstance] identify:@"User_444"
//                                     traits:@{@"firstName": @"Nisha",
//                                              @"LastName": @"Mazumder",
//                                              @"email": @"nishu@hotmail.com",
//                                              @"age" : @2,
//                                              @"Karma": @20
//                                     }];
//    //Traits set - Karma, age
//
//
//    //c. Traits to append
//
//    NSArray *objCArray = [NSArray arrayWithObjects:@"1", @"2", nil];
//    [[RSClient sharedInstance] identify:@"User_444"
//                                     traits:@{@"firstName": @"MS.",
//                                              @"LastName": @"Mazumder",
//                                              @"email": @"nishu@hotmail.com",
//                                              @"somelist": objCArray
//                                     }];
//    //Traits set - firstName, somelist
//
//
//    //d. Traits to prepend
//
//     NSArray *objCArray1 = [NSArray arrayWithObjects:@"10", @"20", nil];
//     [[RSClient sharedInstance] identify:@"User_444"
//                                     traits:@{@"firstName": @"MS.",
//                                              @"LastName": @"Saha",
//                                              @"email": @"nishu@hotmail.com",
//                                              @"some_anothe_rlist": objCArray1
//                                     }];
//
//    //Traits set - LastName, some_anothe_rlist
//
//
//    //e. Traits to set once
//
//    [[RSClient sharedInstance] identify:@"User_444"
//                                     traits:@{
//                                              @"sign_up_date": @"2016-12-01"
//                                     }];
//
//    //Traits set - sign_up_date
//
//    [[RSClient sharedInstance] identify:@"User_444"
//                                     traits:@{
//                                              @"sign_up_date": @"2018-12-01"
//                                     }];
//
//    //Traits set - sign_up_date
//
//     [[RSClient sharedInstance] identify:@"User_444"
//                                     traits:@{
//                                              @"sign_up_date": @"2019-12-01"
//                                     }];
    //No Traits set

    
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
