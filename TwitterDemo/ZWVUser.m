//
//  ZWVUser.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVUser.h"

NSString * const ZWVUserName = @"name";
NSString * const ZWVUserScreenName = @"screen_name";
NSString * const ZWVUserProfileImageURL = @"profile_image_url";

@implementation ZWVUser

- (instancetype)initWithDict:(NSDictionary *)jsonDict {
    if (!(self = [super init])) return nil;
    if (!jsonDict) return nil; // No dict, return nothing
    
    if (jsonDict[ZWVUserName]) {
        self.username = jsonDict[ZWVUserName];
    }
    if (jsonDict[ZWVUserScreenName]) {
        self.screenName = jsonDict[ZWVUserScreenName];
    }
    if (jsonDict[ZWVUserProfileImageURL]) {
        // The normal image size is too small, replace "_normal" with "_bigger"
        NSString *normalImageString = jsonDict[ZWVUserProfileImageURL];
        NSString *newString = [normalImageString stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
        self.profileImageUrl = newString;
    }
    
    return self;
}

@end
