//
//  RudderAmplitudeIntegration.m
//  Rudder-Amplitude
//
//  Created by Desu Sai Venkat on 04/12/20.
//
#import <Amplitude/Amplitude.h>
#import "RudderAmplitudeIntegration.h"
#import <Rudder/Rudder.h>
#import <malloc/malloc.h>

@implementation RudderAmplitudeIntegration

#pragma mark - Initialization

- (instancetype) initWithConfig:(NSDictionary *)config withAnalytics:(nonnull RSClient *)client  withRudderConfig:(nonnull RSConfig *)rudderConfig {
    self = [super init];
    if (self) {
        // do initialization here
        [RSLogger logDebug:@"Initializing Amplitude SDK"];
        dispatch_async(dispatch_get_main_queue(), ^{
            //take values from config
            self.apiKey = [config objectForKey:@"apiKey"];
            
            // page settings
            self.trackAllPages = [[config objectForKey:@"trackAllPages"] boolValue];
            self.trackNamedPages = [[config objectForKey:@"trackNamedPages"] boolValue];
            self.trackCategorizedPages = [[config objectForKey:@"trackCategorizedPages"] boolValue];
            
            //track settings
            self.trackProductsOnce = [[config objectForKey:@"trackProductsOnce"] boolValue];
            self.trackRevenuePerProduct = [[config objectForKey:@"trackRevenuePerProduct"] boolValue];
            
            // traits settings
            self.traitsToIncrement = [[self getNSMutableSet:[config objectForKey:@"traitsToIncrement"]] copy];
            self.traitsToSetOnce = [[self getNSMutableSet:[config objectForKey:@"traitsToSetOnce"]] copy];
            self.traitsToAppend = [[self getNSMutableSet:[config objectForKey:@"traitsToAppend"]] copy];
            self.traitsToPrepend = [[self getNSMutableSet:[config objectForKey:@"traitsToPrepend"]] copy];
            
            //group settings
            self.groupTypeTrait = [config objectForKey:@"groupTypeTrait"];
            self.groupValueTrait = [config objectForKey:@"groupValueTrait"];
            
            
            
            // track session events
            if(self.trackSessionEvents)
            {
                [Amplitude instance].trackingSessionEvents = YES;
            }
            
            // batching configuration
            if(self.eventUploadPeriodMillis)
            {
                [Amplitude instance].eventUploadPeriodSeconds = self.eventUploadPeriodMillis/1000;//[NSNumber numberWithInt:1000];
            }
            
            if(self.eventUploadThreshold)
            {
                [Amplitude instance].eventUploadThreshold = self.eventUploadThreshold;
            }
            
            // location listening
            //            if(self.enableLocationListening)
            //            {
            //                [[Amplitude instance] enableLocationListening];
            //            }
            //            else{
            //                [[Amplitude instance] disableLocationListening];
            //            }
            
            // using Advertising Id for Device Id
            if(self.useAdvertisingIdForDeviceId)
            {
                [[Amplitude instance] useAdvertisingIdForDeviceId];
            }
            
            // Initialize SDK
            [[Amplitude instance] initializeApiKey:self.apiKey];
            
        });
    }
    return self;
}

- (void) dump:(RSMessage *)message {
    @try {
        if (message != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self processRudderEvent:message];
            });
        }
    } @catch (NSException *ex) {
        [RSLogger logError:[[NSString alloc] initWithFormat:@"%@", ex]];
    }
}

- (void) processRudderEvent: (nonnull RSMessage *) message {
    NSString *type = message.type;
    
    if ([type isEqualToString:@"identify"]) {
        // identify
        NSString *userId = message.userId;
        NSDictionary *traits = message.context.traits;
        BOOL optOutOfSession = FALSE;
        optOutOfSession = [traits objectForKey:@"optOutOfSession"];
        if(userId!=nil && userId.length!=0)
        {
            [[Amplitude instance] setUserId:userId];
        }
        if(self.traitsToIncrement!=nil || self.traitsToSetOnce!=nil || self.traitsToAppend!=nil || self.traitsToPrepend!=nil)
        {
            [self handleTraits:traits withOptOutOfSession:optOutOfSession];
            return;
        }
        [[Amplitude instance] setUserProperties:traits];
        AMPIdentify *identify = [AMPIdentify identify];
        [[Amplitude instance] identify:identify outOfSession:optOutOfSession];
    } else if ([type isEqualToString:@"track"]) {
        // track call
        NSString *event = message.event;
        if(event)
        {
            NSDictionary *properties = message.properties;
            NSMutableDictionary *propertiesDictionary = [properties mutableCopy];
            NSArray *products = [propertiesDictionary objectForKey:@"products"];
            
            if(self.trackProductsOnce)
            {
                if(products)
                {
                    NSArray *simplifiedProducts = [self simplifyProducts:products];
                    propertiesDictionary[@"products"]=simplifiedProducts;
                    [self logEventAndCorrespondingRevenue:propertiesDictionary withEventName:event withDoNotTrackRevenue:self.trackRevenuePerProduct];
                    if(self.trackRevenuePerProduct)
                    {
                        [self trackingEventAndRevenuePerProduct:propertiesDictionary withProductsArray:products withTrackEventPerProduct:FALSE];
                    }
                    return;
                }
                [self logEventAndCorrespondingRevenue:propertiesDictionary withEventName:event withDoNotTrackRevenue:FALSE];
                return;
            }
            if(products)
            {
                [propertiesDictionary removeObjectForKey:@"products"];
                [self logEventAndCorrespondingRevenue:propertiesDictionary withEventName:event withDoNotTrackRevenue:self.trackRevenuePerProduct];
                [self trackingEventAndRevenuePerProduct:propertiesDictionary withProductsArray:products withTrackEventPerProduct:TRUE];
                return;
            }
            [self logEventAndCorrespondingRevenue:propertiesDictionary withEventName:event withDoNotTrackRevenue:FALSE];
        }
        
    } else if ([type isEqualToString:@"screen"]) {
        NSDictionary *properties = message.properties;
        if(self.trackAllPages)
        {
            if([properties objectForKey:@"name"] && [[properties objectForKey:@"name"] length] != 0 )
            {
                [[Amplitude instance] logEvent:[NSString stringWithFormat:@"Viewed %@ Screen",[properties objectForKey:@"name"]] withEventProperties:properties withGroups:nil outOfSession:FALSE];
            }
            else{
                [[Amplitude instance] logEvent:@"Loaded a Screen" withEventProperties:properties withGroups:nil outOfSession:FALSE];
            }
        }
        if(self.trackNamedPages && [properties objectForKey:@"name"] && [[properties objectForKey:@"name"] length] != 0)
        {
            [[Amplitude instance] logEvent:[NSString stringWithFormat:@"Viewed %@ Screen",[properties objectForKey:@"name"]] withEventProperties:properties withGroups:nil outOfSession:FALSE];
        }
        if(self.trackCategorizedPages && [properties objectForKey:@"category"] && [[properties objectForKey:@"category"] length] != 0)
        {
            [[Amplitude instance] logEvent:[NSString stringWithFormat:@"Viewed %@ Screen",[properties objectForKey:@"category"]] withEventProperties:properties withGroups:nil outOfSession:FALSE];
        }
    } else if ([type isEqualToString:@"group"]) {
        NSString *groupType;
        NSString *groupName = message.userId;
        NSDictionary *groupTraits = message.context.traits;
        if(groupTraits && [self getDictionarySize:groupTraits]!=0)
        {
            if([groupTraits objectForKey:self.groupTypeTrait] && [groupTraits objectForKey:self.groupValueTrait])
            {
                groupType = [groupTraits objectForKey:self.groupTypeTrait];
                groupName = [groupTraits objectForKey:self.groupValueTrait];
            }
        }
        if(!groupName)
        {
            groupName = @"[RudderStack] Group";
        }
        
        // setting group
        [[Amplitude instance] setGroup:groupType groupName:groupName];
        
        // Set group properties
        AMPIdentify *groupIdentify = [AMPIdentify identify];
        [groupIdentify set:@"library" value:@"RudderStack"];
        if(groupTraits && [self getDictionarySize:groupTraits]!=0)
        {
            [groupIdentify set:@"group_properties" value:groupTraits];
        }
        [[Amplitude instance] groupIdentifyWithGroupType:groupType groupName:groupName groupIdentify:groupIdentify];
    } else {
        [RSLogger logDebug:@"Amplitude Integration: Message Type not supported"];
    }
}

- (void)reset {
    [[Amplitude instance] setUserId:nil]; // not string nil
    [[Amplitude instance] regenerateDeviceId];
}

- (void)flush {
    [[Amplitude instance] uploadEvents];
}

#pragma mark - Utils

-(void) handleTraits:(NSDictionary*) traits withOptOutOfSession:(BOOL) optOutOfSession {
    AMPIdentify *identify = [AMPIdentify identify];
    for(id key in traits)
    {
        if([self.traitsToIncrement containsObject:key])
        {
            [identify add:key value:[traits objectForKey:key]];
            // need to check if amplitude native sdk supports more than one operation on the same key in a identify call
            continue;
        }
        if([self.traitsToSetOnce containsObject:key])
        {
            [identify setOnce:key value:[traits objectForKey:key]];
            // need to check if amplitude native sdk supports more than one operation on the same key in a identify call
            continue;
        }
        if([self.traitsToAppend containsObject:key])
        {
            [identify append:key value:[traits objectForKey:key]];
            // need to check if amplitude native sdk supports more than one operation on the same key in a identify call
            continue;
        }
        if([self.traitsToPrepend containsObject:key])
        {
            [identify prepend:key value:[traits objectForKey:key]];
            // need to check if amplitude native sdk supports more than one operation on the same key in a identify call
            continue;
        }
        [identify set:key value:[traits objectForKey:key]];
    }
    [[Amplitude instance] identify:identify outOfSession:optOutOfSession];
}

- (NSMutableSet*) getNSMutableSet: (NSArray*) array {
    NSMutableSet *mutableSet = [[NSMutableSet alloc ]init];
    for (id obj in array)
    {
        [mutableSet addObject:[obj objectForKey:@"traits"]];
    }
    return mutableSet;
}

- (NSNumber*) getDictionarySize: (NSDictionary*) groupTraits {
    NSArray *keysArray = [groupTraits allValues];
    int totalSize = 0;
    for(id obj in keysArray)
    {
        totalSize += malloc_size((__bridge const void *)obj);
    }
    return [NSNumber numberWithInt:totalSize];
}

- (NSArray*) simplifyProducts: (NSArray*) products {
    
    NSMutableArray* simplifiedProducts = [[NSMutableArray alloc]init];
    for(NSDictionary *product in products)
    {
        NSMutableDictionary* simplifiedProduct = [[NSMutableDictionary alloc] init];
        simplifiedProduct[@"productId"] = product[@"productId"]?:product[@"product_id"];
        simplifiedProduct[@"sku"] = product[@"sku"];
        simplifiedProduct[@"category"] = product[@"category"];
        simplifiedProduct[@"name"] = product[@"name"];
        simplifiedProduct[@"price"] = product[@"price"];
        simplifiedProduct[@"quantity"] = product[@"quantity"];
        [simplifiedProducts addObject:simplifiedProduct];
    }
    return simplifiedProducts;
}

// revenue methods

- (void) logEventAndCorrespondingRevenue: (NSMutableDictionary*) eventProperties withEventName: (NSString*) eventName withDoNotTrackRevenue: (BOOL) doNotTrackRevenue {
    
    if(!eventProperties)
    {
        [[Amplitude instance] logEvent:eventName];
        return;
    }
    BOOL optOutOfSession = [eventProperties objectForKey:@"optOutOfSession"];
    [[Amplitude instance] logEvent:eventName withEventProperties:eventProperties withGroups:nil outOfSession:optOutOfSession];
    if([eventProperties objectForKey:@"revenue"] && !doNotTrackRevenue)
    {
        [self trackRevenue:eventProperties withEventName:eventName];
    }
    
}

- (void) trackingEventAndRevenuePerProduct: (NSMutableDictionary*) eventProperties withProductsArray: (NSArray*) products withTrackEventPerProduct: (BOOL) trackEventPerProduct {
    NSString *revenueType = eventProperties[@"revenueType"]?:eventProperties[@"revenue_type"]?:nil;
    for(NSMutableDictionary *product in products)
    {
        if(self.trackRevenuePerProduct)
        {
            if(revenueType)
            {
                product[@"revenueType"]=revenueType;
            }
            [self trackRevenue:product withEventName:@"Product Purchased"];
        }
        if(trackEventPerProduct)
        {
            [self logEventAndCorrespondingRevenue:product withEventName:@"Product Purchased" withDoNotTrackRevenue:TRUE];
        }
    }
}

- (void) trackRevenue: (NSMutableDictionary*) eventProperties withEventName: (NSString*) eventName {
    
    NSDictionary *mapRevenueType = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    @"Purchase",@"order completed",
                                    @"Purchase", @"completed order",
                                    @"Purchase",@"product purchased",
                                    nil
                                    ];
    
    NSNumber *quantity = eventProperties[@"quantity"];
    NSNumber *revenue = eventProperties[@"revenue"];
    NSNumber *price = eventProperties[@"price"];
    NSString *productId = eventProperties[@"productId"]?:eventProperties[@"product_id"]?:nil;
    NSString *revenueType = eventProperties[@"revenueType"]?:eventProperties[@"revenue_type"]?:mapRevenueType[[eventName lowercaseString]];
    NSData * receipt;
    if(eventProperties[@"receipt"])
    {
        receipt = [NSKeyedArchiver archivedDataWithRootObject:eventProperties[@"receipt"]];
    }
    if(!revenue && !price )
    {
        [RSLogger logDebug:@"revenue or price is not present."];
        return;
    }
    if(price == 0)
    {
        price = revenue;
        quantity = [NSNumber numberWithInt:1];
    }
    if(quantity == 0)
    {
        quantity = [NSNumber numberWithInt:1];
    }
    AMPRevenue *ampRevenue = [AMPRevenue revenue];
    [[[ampRevenue setPrice:price]setQuantity:[quantity integerValue]]setEventProperties:eventProperties];
    if(revenueType)
    {
        [ampRevenue setRevenueType:revenueType];
    }
    if(productId)
    {
        [ampRevenue setProductIdentifier:productId];
    }
    if(receipt)
    {
        [ampRevenue setReceipt:receipt];
    }
    [[Amplitude instance] logRevenueV2:ampRevenue];
    
}

@end
