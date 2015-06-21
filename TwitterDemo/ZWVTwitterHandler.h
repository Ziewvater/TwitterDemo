//
//  ZWVTwitterAuthenticator.h
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/20/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STTwitter/STTwitter.h>

/**
 Handles Twitter API authentication, and holds on and provides access to the
 authenticated twitter API object after the authentication process is finished.
 */
@interface ZWVTwitterHandler : NSObject

@property (strong, nonatomic) STTwitterAPI *twitterAPI;

+ (instancetype)shared;

/**
 Performs reverse authentication with one of the Twitter accounts stored to the
 device.
 
 @param completion   Block that fires when Twitter authentication is 
 successfully completed. Offers access to the newly authenticated twitter API 
 object.
 @param errorHandler Block that fires when an error is encountered performing
 the reverse authentication process.
 */
- (void)performReverseAuthentication:(void (^)(STTwitterAPI *twitterAPI))completion errorHandler:(void(^)(NSError *error))errorHandler;

@end
