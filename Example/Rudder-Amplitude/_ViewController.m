//
//  _ViewController.m
//  Rudder-Amplitude
//
//  Created by Arnab on 11/18/2020.
//  Copyright (c) 2020 Arnab. All rights reserved.
//

#import "_ViewController.h"
#import <Rudder/Rudder.h>

@interface _ViewController ()

@end

@implementation _ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)identify:(id)sender {
    [[RSClient sharedInstance] identify:@"JamesBond"
                                 traits:@{@"firstName": @"James",
                                          @"LastName": @"Bond",
                                          @"email": @"Bond@james.com",
                                          @"friends":[NSNumber numberWithInt:10],
                                          @"city":@"CA",
                                          @"awards":[NSNumber numberWithInt:1],
                                          @"rewards":@"11"
                                        }];
}

- (IBAction)track_withoutProperties:(id)sender {
    [[RSClient sharedInstance] track:@"simple_track_event"];
}

- (IBAction)track_withProperties:(id)sender {
    [[RSClient sharedInstance] track:@"simple_track_with_props" properties:@{
        @"key_1" : @"value_1",
        @"key_2" : @"value_2"
    }];
}

- (IBAction)track_withProperties2:(id)sender {
    [[RSClient sharedInstance] track:@"Order Done" properties:@{
        @"revenue" : @100,
        @"orderId" : @"ooo1111111",
        @"products" : @[
            @{
                @"productId" : @"12##89",
                @"price" : @12,
                @"quantity" : @1
            },
            @{
                @"productId" : @"8900",
                @"price" : @21,
                @"quantity" : @3
            }
        ]
    }];
}

- (IBAction)screen:(id)sender {
    [[RSClient sharedInstance] screen:@"The Cinema"  properties:@{@"prop_key" : @"prop_value",@"category":@"TENET"}];
}

- (IBAction)reset:(id)sender {
    [[RSClient sharedInstance] reset];
}

- (IBAction)flush:(id)sender {
    [[RSClient sharedInstance] flush];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
