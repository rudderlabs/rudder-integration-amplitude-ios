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
#import "AMPServerZone.h"

@implementation AmplitudeConfig
@end

@implementation RudderAmplitudeIntegration

#pragma mark - Initialization

- (instancetype) initWithConfig:(NSDictionary *)config withAnalytics:(nonnull RSClient *)client  withRudderConfig:(nonnull RSConfig *)rudderConfig {
    
    self = [super init];
    if (self) {
        // do initialization here
        [RSLogger logDebug:@"Initializing Amplitude SDK"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self->amplitudeConfig = [self createAMPConfigurationFromDestConfig:config];
            
            if(self->amplitudeConfig.residencyServer){
                NSString *residencyServer = self->amplitudeConfig.residencyServer;
                AMPServerZone serverZone = (residencyServer = @"EU") ? EU : US;
                [[Amplitude instance] setServerZone: serverZone];
            }
            
            // track session events
            if(self->amplitudeConfig.trackSessionEvents) {
                [Amplitude instance].trackingSessionEvents = YES;
            }
            
            // batching configuration
            if(self->amplitudeConfig.eventUploadPeriodMillis) {
                [Amplitude instance].eventUploadPeriodSeconds = self->amplitudeConfig.eventUploadPeriodMillis/1000;
            }
            
            if(self->amplitudeConfig.eventUploadThreshold) {
                [Amplitude instance].eventUploadThreshold = self->amplitudeConfig.eventUploadThreshold;
            }
            
            if(self->amplitudeConfig.eventUploadThreshold) {
                [Amplitude instance].eventUploadThreshold = self->amplitudeConfig.eventUploadThreshold;
            }
            // using Advertising Id for Device Id
            if(self->amplitudeConfig.useAdvertisingIdForDeviceId) {
                [[Amplitude instance] useAdvertisingIdForDeviceId];
            }
            int eventUploadPeriodMillis =self->amplitudeConfig.eventUploadPeriodMillis;
            if(eventUploadPeriodMillis && eventUploadPeriodMillis> 0){
                [Amplitude instance].eventUploadPeriodSeconds = (eventUploadPeriodMillis/1000);
            }
            
            int eventUploadMaxBatchSize =self->amplitudeConfig.eventUploadMaxBatchSize;
            if(eventUploadMaxBatchSize && eventUploadMaxBatchSize> 0){
                [Amplitude instance].eventUploadMaxBatchSize = eventUploadMaxBatchSize;
            }
            
            int eventMaxCount =self->amplitudeConfig.eventMaxCount;
            if(eventMaxCount && eventMaxCount> 0){
                [Amplitude instance].eventMaxCount = eventMaxCount;
            }
            
            int minTimeBetweenSessionsMillis =self-> amplitudeConfig.minTimeBetweenSessionMillis;
            if(minTimeBetweenSessionsMillis && minTimeBetweenSessionsMillis> 0){
                [Amplitude instance].minTimeBetweenSessionsMillis = minTimeBetweenSessionsMillis;
            }
            
            NSString *serverUrl =self-> amplitudeConfig.serverUrl;
            if(serverUrl && serverUrl.length> 0){
                [Amplitude instance].serverUrl = serverUrl;
            }
            
            BOOL *optOut =self-> amplitudeConfig.optOut;
            if(optOut){
                [Amplitude instance].optOut = optOut;
            }
            [[Amplitude instance] setTrackingOptions: self->amplitudeConfig.trackingOptions];
            
            BOOL *offline =self-> amplitudeConfig.offline;
            if(offline){
                [[Amplitude instance] setOffline: self->amplitudeConfig.offline];
            }

            // Initialize SDK
            [[Amplitude instance] initializeApiKey:self->amplitudeConfig.apiKey];
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
    }
    @catch (NSException *ex) {
        [RSLogger logError:[[NSString alloc] initWithFormat:@"%@", ex]];
    }
}

- (void) processRudderEvent: (nonnull RSMessage *) message {
    NSString *type = message.type;
    if ([type isEqualToString:@"identify"]) {
        // identify
        NSString *userId     = message.userId;
        NSDictionary *traits = message.context.traits;
        BOOL optOutOfSession = [traits objectForKey:@"optOutOfSession"];
        if(userId != nil && userId.length != 0) {
            [[Amplitude instance] setUserId:userId];
        }
        [self handleTraits:traits withOptOutOfSession:optOutOfSession];
    }
    else if ([type isEqualToString:@"track"]) {
        // track call
        NSString *event = message.event;
        if(event) {
            NSMutableDictionary *propertiesDictionary = [message.properties mutableCopy];
            NSArray *products                         = [propertiesDictionary objectForKey:@"products"];
            
            if(amplitudeConfig.trackProductsOnce) {
                if(products)
                {
                    NSArray *simplifiedProducts       = [self simplifyProducts:products];
                    propertiesDictionary[@"products"] = simplifiedProducts;
                    [self logEventAndCorrespondingRevenue:propertiesDictionary
                                            withEventName:event
                                    withDoNotTrackRevenue:amplitudeConfig.trackRevenuePerProduct];
                    
                    if(amplitudeConfig.trackRevenuePerProduct)
                    {
                        [self trackingEventAndRevenuePerProduct:propertiesDictionary
                                              withProductsArray:products
                                       withTrackEventPerProduct:FALSE];
                    }
                    return;
                }
                [self logEventAndCorrespondingRevenue:propertiesDictionary
                                        withEventName:event
                                withDoNotTrackRevenue:FALSE];
                return;
            }
            if(products) {
                [propertiesDictionary removeObjectForKey:@"products"];
                [self logEventAndCorrespondingRevenue:propertiesDictionary
                                        withEventName:event
                                withDoNotTrackRevenue:amplitudeConfig.trackRevenuePerProduct];
                [self trackingEventAndRevenuePerProduct:propertiesDictionary
                                      withProductsArray:products
                               withTrackEventPerProduct:TRUE];
                return;
            }
            [self logEventAndCorrespondingRevenue:propertiesDictionary
                                    withEventName:event
                            withDoNotTrackRevenue:FALSE];
        }
    }
    else if ([type isEqualToString:@"screen"]) {
        NSDictionary *properties = message.properties;
        if(amplitudeConfig.trackAllPages) {
            if([properties objectForKey:@"name"] &&
               [[properties objectForKey:@"name"] length] != 0 ) {
                [[Amplitude instance] logEvent:[NSString stringWithFormat:@"Viewed %@ Screen",
                                                [properties objectForKey:@"name"]]
                           withEventProperties:properties withGroups:nil
                                  outOfSession:FALSE];
            }
            else {
                [[Amplitude instance] logEvent:@"Loaded a Screen"
                           withEventProperties:properties
                                    withGroups:nil
                                  outOfSession:FALSE];
            }
        }
        
        if(amplitudeConfig.trackNamedPages &&
           [properties objectForKey:@"name"] &&
           [[properties objectForKey:@"name"] length] != 0) {
            [[Amplitude instance] logEvent:[NSString stringWithFormat:@"Viewed %@ Screen",
                                            [properties objectForKey:@"name"]]
                       withEventProperties:properties
                                withGroups:nil
                              outOfSession:FALSE];
        }
        
        if(amplitudeConfig.trackCategorizedPages &&
           [properties objectForKey:@"category"] &&
           [[properties objectForKey:@"category"] length] != 0) {
            [[Amplitude instance] logEvent:[NSString stringWithFormat:@"Viewed %@ Screen",
                                            [properties objectForKey:@"category"]]
                       withEventProperties:properties
                                withGroups:nil
                              outOfSession:FALSE];
        }
    }
//    else if ([type isEqualToString:@"group"]) {
//        NSString *groupType;
//        NSString *groupName = message.groupId;
//        NSDictionary *groupTraits = message.traits;
//        if(groupTraits && [self getDictionarySize:groupTraits]!=0)
//        {
//            if([groupTraits objectForKey:self.groupTypeTrait] && [groupTraits objectForKey:self.groupValueTrait])
//            {
//                groupType = [groupTraits objectForKey:self.groupTypeTrait];
//                groupName = [groupTraits objectForKey:self.groupValueTrait];
//            }
//        }
//        if(!groupType)
//        {
//            groupType = @"[RudderStack] Group";
//        }
//
//        // setting group
//        [[Amplitude instance] setGroup:groupType groupName:groupName];
//
//        // Set group properties
//        AMPIdentify *groupIdentify = [AMPIdentify identify];
//        [groupIdentify set:@"library" value:@"RudderStack"];
//        if(groupTraits && [self getDictionarySize:groupTraits]!=0)
//        {
//            [groupIdentify set:@"group_properties" value:groupTraits];
//        }
//        [[Amplitude instance] groupIdentifyWithGroupType:groupType groupName:groupName groupIdentify:groupIdentify];
//    }
    else {
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
    for(id key in traits) {
        if([amplitudeConfig.traitsToIncrement containsObject:key]) {
            [identify add:key value:[traits objectForKey:key]];
            // need to check if amplitude native sdk supports
            // more than one operation on the same key in a identify call
            continue;
        }
        if([amplitudeConfig.traitsToSetOnce containsObject:key]) {
            [identify setOnce:key value:[traits objectForKey:key]];
            // need to check if amplitude native sdk supports
            // more than one operation on the same key in a identify call
            continue;
        }
        if([amplitudeConfig.traitsToAppend containsObject:key]) {
            [identify append:key value:[traits objectForKey:key]];
            // need to check if amplitude native sdk supports
            // more than one operation on the same key in a identify call
            continue;
        }
        if([amplitudeConfig.traitsToPrepend containsObject:key]) {
            [identify prepend:key value:[traits objectForKey:key]];
            // need to check if amplitude native sdk supports
            // more than one operation on the same key in a identify call
            continue;
        }
        [identify set:key value:[traits objectForKey:key]];
    }
    [[Amplitude instance] identify:identify outOfSession:optOutOfSession];
}



- (NSNumber*) getDictionarySize: (NSDictionary*) groupTraits {
    NSArray *keysArray = [groupTraits allValues];
    int totalSize = 0;
    for(id obj in keysArray) {
        totalSize += malloc_size((__bridge const void *)obj);
    }
    return [NSNumber numberWithInt:totalSize];
}

- (NSArray*) simplifyProducts: (NSArray*) products {
    
    NSMutableArray* simplifiedProducts = [[NSMutableArray alloc]init];
    for(NSDictionary *product in products) {
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
    
    if(!eventProperties) {
        [[Amplitude instance] logEvent:eventName];
        return;
    }
    BOOL optOutOfSession = [eventProperties objectForKey:@"optOutOfSession"];
    [[Amplitude instance] logEvent:eventName
               withEventProperties:eventProperties
                        withGroups:nil
                      outOfSession:optOutOfSession];
    
    if([eventProperties objectForKey:@"revenue"] && !doNotTrackRevenue) {
        [self trackRevenue:eventProperties withEventName:eventName];
    }
}

- (void) trackingEventAndRevenuePerProduct: (NSMutableDictionary*) eventProperties withProductsArray: (NSArray*) products withTrackEventPerProduct: (BOOL) trackEventPerProduct {
    NSString *revenueType = eventProperties[@"revenueType"]
                            ?:eventProperties[@"revenue_type"]
                            ?:nil;
    for(NSMutableDictionary *product in products) {
        if(amplitudeConfig.trackRevenuePerProduct) {
            if(revenueType) {
                product[@"revenueType"]=revenueType;
            }
            [self trackRevenue:product withEventName:@"Product Purchased"];
        }
        if(trackEventPerProduct) {
            [self logEventAndCorrespondingRevenue:product
                                    withEventName:@"Product Purchased"
                            withDoNotTrackRevenue:TRUE];
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
    
    NSNumber *quantity;
    if(eventProperties[@"quantity"] &&
       [[NSString stringWithFormat:@"%@", eventProperties[@"quantity"]] length] != 0) {
        quantity = eventProperties[@"quantity"];
    }
    
    NSNumber *revenue;
    if(eventProperties[@"revenue"] &&
       [[NSString stringWithFormat:@"%@", eventProperties[@"revenue"]] length] != 0) {
        revenue = eventProperties[@"revenue"];
    }
    
    NSNumber *price;
    if(eventProperties[@"price"] &&
       [[NSString stringWithFormat:@"%@", eventProperties[@"price"]] length] != 0) {
        price = eventProperties[@"price"];
    }
    
    NSString *productId = eventProperties[@"productId"]
                          ?:eventProperties[@"product_id"]?:nil;
    NSString *revenueType = eventProperties[@"revenueType"]
                            ?:eventProperties[@"revenue_type"]
                            ?:mapRevenueType[[eventName lowercaseString]];
    NSData * receipt;
    if(eventProperties[@"receipt"]) {
        receipt = [NSKeyedArchiver archivedDataWithRootObject:eventProperties[@"receipt"]];
    }
    if(!revenue && !price ) {
        [RSLogger logDebug:@"revenue or price is not present."];
        return;
    }
    if(price == 0) {
        price = revenue;
        quantity = [NSNumber numberWithInt:1];
    }
    if(quantity == 0) {
        quantity = [NSNumber numberWithInt:1];
    }
    AMPRevenue *ampRevenue = [AMPRevenue revenue];
    [[[ampRevenue setPrice:price] setQuantity:[quantity integerValue]] setEventProperties:eventProperties];
    if(revenueType && [revenueType length]!=0) {
        [ampRevenue setRevenueType:revenueType];
    }
    if(productId && [productId length]!=0) {
        [ampRevenue setProductIdentifier:productId];
    }
    if(receipt) {
        [ampRevenue setReceipt:receipt];
    }
    [[Amplitude instance] logRevenueV2:ampRevenue];
}

- (AmplitudeConfig *)createAMPConfigurationFromDestConfig: (NSDictionary *) destinationConfig {
    //take values from destinationConfig
    AmplitudeConfig *amplitudeConfig = [[AmplitudeConfig alloc] init];
    amplitudeConfig.apiKey = [destinationConfig objectForKey:@"apiKey"];
    
    // page settings
    amplitudeConfig.trackAllPages           = [[destinationConfig objectForKey:@"trackAllPages"] boolValue];
    amplitudeConfig.trackNamedPages         = [[destinationConfig objectForKey:@"trackNamedPages"] boolValue];
    amplitudeConfig.trackCategorizedPages   = [[destinationConfig objectForKey:@"trackCategorizedPages"] boolValue];
    
    //track settings
    amplitudeConfig.trackProductsOnce       = [[destinationConfig objectForKey:@"trackProductsOnce"] boolValue];
    amplitudeConfig.trackRevenuePerProduct  = [[destinationConfig objectForKey:@"trackRevenuePerProduct"] boolValue];
    
    // traits settings
    amplitudeConfig.traitsToIncrement       = [self getNSMutableSet:[destinationConfig objectForKey:@"traitsToIncrement"]];
    amplitudeConfig.traitsToSetOnce         = [self getNSMutableSet:[destinationConfig objectForKey:@"traitsToSetOnce"]] ;
    amplitudeConfig.traitsToAppend          = [self getNSMutableSet:[destinationConfig objectForKey:@"traitsToAppend"]];
    amplitudeConfig.traitsToPrepend         = [self getNSMutableSet:[destinationConfig objectForKey:@"traitsToPrepend"]];
    
    //group settings
    amplitudeConfig.groupTypeTrait          = [destinationConfig objectForKey:@"groupTypeTrait"];
    amplitudeConfig.groupValueTrait         = [destinationConfig objectForKey:@"groupValueTrait"];
    
    // destinationConfig settings
    amplitudeConfig.trackSessionEvents      = [[destinationConfig objectForKey:@"trackSessionEvents"] boolValue];
    amplitudeConfig.eventUploadPeriodMillis = [[destinationConfig objectForKey:@"eventUploadPeriodMillis"] intValue];
    amplitudeConfig.eventUploadThreshold    = [[destinationConfig objectForKey:@"eventUploadThreshold"] intValue];
    amplitudeConfig.useAdvertisingIdForDeviceId    = [[destinationConfig objectForKey:@"useAdvertisingIdForDeviceId"] boolValue];
    amplitudeConfig.residencyServer    = [[destinationConfig objectForKey:@"residencyServer"] stringValue];
    amplitudeConfig.serverUrl    = [[destinationConfig objectForKey:@"serverUrl"] stringValue];
    amplitudeConfig.enableCoppaControl = [[destinationConfig objectForKey:@"enableCoppaControl"] boolValue];
    amplitudeConfig.minTimeBetweenSessionMillis = [[destinationConfig objectForKey:@"minTimeBetweenSessionMillis"] intValue];
    amplitudeConfig.identifyBatchIntervalMillis = [[destinationConfig objectForKey:@"identifyBatchIntervalMillis"] intValue];
    amplitudeConfig.optOut = [[destinationConfig objectForKey:@"optOut"] boolValue];
    amplitudeConfig.offline = [[destinationConfig objectForKey:@"Offline"] boolValue];
    amplitudeConfig.identifyUploadPeriodSeconds = [[destinationConfig objectForKey:@"identifyUploadPeriodSeconds"] intValue];

    //plan
    NSDictionary *ampPlan;
    ampPlan = [destinationConfig objectForKey:@"plan"];
    if(ampPlan){
        AMPPlan *plan = [[AMPPlan alloc] init];
        plan.branch = [[ampPlan objectForKey:@"branch"] stringValue];
        plan.source = [[ampPlan objectForKey:@"source"] stringValue];
        plan.version = [[ampPlan objectForKey:@"version"] stringValue];
        plan.versionId = [[ampPlan objectForKey:@"versionId"] stringValue];
        amplitudeConfig.plan = plan;
    }
    //ingestion meta data
    NSDictionary *ampIngestionMetadata;
    ampIngestionMetadata = [destinationConfig objectForKey:@"ingestionMetadata"];
    if(ampPlan){
        AMPIngestionMetadata *ingestionMetadata = [[AMPIngestionMetadata alloc] init];
        ingestionMetadata.sourceName = [[ampPlan objectForKey:@"sourceName"] stringValue];
        ingestionMetadata.sourceVersion = [[ampPlan objectForKey:@"sourceVersion"] stringValue];
        amplitudeConfig.ingestionMetadata = ingestionMetadata;
    }
    //tracking options
    AMPTrackingOptions *trackingOptions = [[AMPTrackingOptions alloc] init];
    NSDictionary *amplitudeTrackingConfig = [destinationConfig objectForKey:@"trackingOptions"];
    if(amplitudeTrackingConfig){
        
        if(! [[amplitudeTrackingConfig objectForKey: @"carrier"] boolValue]){
            trackingOptions.disableCarrier;
        }
        if(! [[amplitudeTrackingConfig objectForKey: @"city"] boolValue]){
            trackingOptions.disableCity;
        }
        if(! [[amplitudeTrackingConfig objectForKey: @"country"] boolValue]){
            trackingOptions.disableCountry;
        }
        if(! [[amplitudeTrackingConfig objectForKey: @"deviceModel"] boolValue]){
            trackingOptions.disableDeviceModel;
        }
        if(! [[amplitudeTrackingConfig objectForKey: @"dma"] boolValue]){
            trackingOptions.disableDMA;
        }
        if(! [[amplitudeTrackingConfig objectForKey: @"ipAddress"] boolValue]){
            trackingOptions.disableIPAddress;
        }
        if(! [[amplitudeTrackingConfig objectForKey: @"language"] boolValue]){
            trackingOptions.disableLanguage;
        }
        if(! [[amplitudeTrackingConfig objectForKey: @"latlng"] boolValue]){
            trackingOptions.disableLatLng;
        }
        if(! [[amplitudeTrackingConfig objectForKey: @"osName"] boolValue]){
            trackingOptions.disableOSName;
        }
        if(! [[amplitudeTrackingConfig objectForKey: @"osVersion"] boolValue]){
            trackingOptions.disableOSVersion;
        }
        if(! [[amplitudeTrackingConfig objectForKey: @"region"] boolValue]){
            trackingOptions.disableRegion;
        }
        if(! [[amplitudeTrackingConfig objectForKey: @"versionName"] boolValue]){
            trackingOptions.disableVersionName;
        }
        
        if(! [[amplitudeTrackingConfig objectForKey: @"idfa"] boolValue]){
            trackingOptions.disableIDFA;
        }
        
        if(! [[amplitudeTrackingConfig objectForKey: @"idfv"] boolValue]){
            trackingOptions.disableIDFV;
        }
        
    }
    amplitudeConfig.trackingOptions = trackingOptions;
    return amplitudeConfig;
}

- (NSMutableSet *) getNSMutableSet: (NSArray*) array {
    NSMutableSet *mutableSet = [[NSMutableSet alloc ]init];
    for (id obj in array) {
        [mutableSet addObject:[obj objectForKey:@"traits"]];
    }
    return mutableSet;
}

@end
