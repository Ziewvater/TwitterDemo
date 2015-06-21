//
//  ZWVTwitterAuthenticator.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/20/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVTwitterHandler.h"
#import <UIKit/UIKit.h>

NSString * const ZWVTwitterConsumerKey = @"hANqfzJFoKWLLrmEJPXyDysVe";
NSString * const ZWVTwitterConsumerSecret = @"jLoCcwulOCLD2IY11Vs5U1KudJ77QFkqoJzecsH27MzS3yKw3g";

@implementation ZWVTwitterHandler

+ (instancetype)shared {
    static ZWVTwitterHandler *twitterHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        twitterHandler = [[self alloc] init];
    });
    return twitterHandler;
}

- (void)performReverseAuthentication:(void (^)(STTwitterAPI *twitterAPI))completion errorHandler:(void(^)(NSError *error))errorHandler {
    NSLog(@"Authenticating");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    __weak __typeof(self)weakSelf = self;
    STTwitterAPI *twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:ZWVTwitterConsumerKey consumerSecret:ZWVTwitterConsumerSecret];
    [twitterAPI postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
        STTwitterAPI *api = [STTwitterAPI twitterAPIOSWithFirstAccount];
        [api verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
            [api postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader
                                                       successBlock:^(NSString *oAuthToken, NSString *oAuthTokenSecret, NSString *userID, NSString *screenName) {
                                                           [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                           weakSelf.twitterAPI = api;
                                                           NSLog(@"Twitter authentication successful");
                                                           if (completion) {
                                                               completion(api);
                                                           }
                                                       }
                                                         errorBlock:^(NSError *error) {
                                                             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                             NSLog(@"Failed to post reverse auth: %@", error);
                                                             if (errorHandler) {
                                                                 errorHandler(error);
                                                             }
                                                         }];
        }
                                        errorBlock:^(NSError *error) {
                                            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                            NSLog(@"Failed to verify; %@", error);
                                            if (errorHandler) {
                                                errorHandler(error);
                                            }
                                        }];
    } errorBlock:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"Failed to post OAuth: %@", error);
        if (errorHandler) {
            errorHandler(error);
        }
    }];
}

@end
