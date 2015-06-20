//
//  ZWVTweetAnnotation.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/20/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVTweetAnnotation.h"

@implementation ZWVTweetAnnotation

- (instancetype)initWithTweet:(ZWVTweet *)tweet {
    if (!(self = [super init])) return nil;
    if (!tweet) return nil;
    
    self.tweet = tweet;
    self.coordinate = tweet.location;
    self.title = tweet.user.username;
    self.subtitle = tweet.text;
    
    return self;
}

@end
