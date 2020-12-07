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
            NSString *apiKey = [config objectForKey:@"apiKey"];
            
            // page settings
            self.trackAllPages = [config objectForKey:@"trackAllPages"];
            self.trackNamedPages = [config objectForKey:@"trackNamedPages"];
            self.trackCategorizedPages = [config objectForKey:@"trackCategorizedPages"];
            
            // traits settings
            self.traitsToIncrement = [[self getNSMutableSet:[config objectForKey:@"traitsToIncrement"]] copy];
            self.traitsToSetOnce = [[self getNSMutableSet:[config objectForKey:@"traitsToSetOnce"]] copy];
            self.traitsToAppend = [[self getNSMutableSet:[config objectForKey:@"traitsToAppend"]] copy];
            self.traitsToPrepend = [[self getNSMutableSet:[config objectForKey:@"traitsToPrepend"]] copy];
            
            //group settings
            self.groupTypeTrait = [config objectForKey:@"groupTypeTrait"];
            self.groupValueTrait = [config objectForKey:@"groupValueTrait"];
            
            // Initialize SDK
            [Amplitude instance].trackingSessionEvents = YES;
            [[Amplitude instance] initializeApiKey:apiKey];
            
            
            [[Amplitude instance] setGroup:@"Desu" groupName:@"Sai"];
            AMPIdentify *groupIdentify = [AMPIdentify identify];
            [groupIdentify set:@"library" value:@"RudderStack"];
            [[Amplitude instance] groupIdentifyWithGroupType:@"Desu" groupName:@"Sai" groupIdentify:groupIdentify];
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
        if(userId!=nil && userId.length!=0)
        {
            [[Amplitude instance] setUserId:userId];
        }
        if(self.traitsToIncrement!=nil || self.traitsToSetOnce!=nil || self.traitsToAppend!=nil || self.traitsToPrepend!=nil)
        {
            [self handleTraits:traits];
            return;
        }
        [[Amplitude instance] setUserProperties:traits];
    } else if ([type isEqualToString:@"track"]) {
        // track call
        NSString *event = message.event;
        NSDictionary *properties = message.properties;
        if(event)
        {
            if(properties)
            {
                [[Amplitude instance] logEvent:event withEventProperties:properties withGroups:nil outOfSession:FALSE];
                return;
            }
            [[Amplitude instance] logEvent:event withEventProperties:nil withGroups:nil outOfSession:FALSE];
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
        NSString *groupType ;
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

-(void) handleTraits:(NSDictionary*) traits {
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
    [[Amplitude instance] identify:identify];
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

@end
