//
//  _ViewController.m
//  Rudder-Amplitude
//
//  Created by Arnab on 11/18/2020.
//  Copyright (c) 2020 Arnab. All rights reserved.
//

#import "_ViewController.h"
#import <Rudder/Rudder.h>
#import "RudderAmplitudeFactory.h"
#import <Amplitude/Amplitude.h>

@interface _ViewController ()

@end

@implementation _ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)callReset:(id)sender {
    
    [[RSClient sharedInstance] reset];
}

- (IBAction)callTrack:(id)sender {
    
    [[RSClient sharedInstance] track:@"simple_track_with_props" properties:@{
        @"key_1" : @"value_1",
        @"key_2" : @"value_2"
    }];
}


@end
