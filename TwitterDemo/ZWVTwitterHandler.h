//
//  ZWVTwitterAuthenticator.h
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/20/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STTwitter/STTwitter.h>

@interface ZWVTwitterHandler : NSObject

@property (strong, nonatomic) STTwitterAPI *twitterAPI;

+ (instancetype)shared;

- (void)performReverseAuthentication:(void (^)(STTwitterAPI *twitterAPI))completion errorHandler:(void(^)(NSError *error))errorHandler;

@end
