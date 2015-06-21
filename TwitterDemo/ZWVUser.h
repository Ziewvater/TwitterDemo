//
//  ZWVUser.h
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Represents a Twitter user.
 */
@interface ZWVUser : NSObject

/// Display name for the user
@property (strong, nonatomic) NSString *username;
/// The unique name for the user ("@" name)
@property (strong, nonatomic) NSString *screenName;
/// URL string for the user's profile image
@property (strong, nonatomic) NSString *profileImageUrl;

- (instancetype)initWithDict:(NSDictionary *)jsonDict;

@end
