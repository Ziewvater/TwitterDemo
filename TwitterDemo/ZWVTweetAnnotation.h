//
//  ZWVTweetAnnotation.h
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/20/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ZWVTweet.h"

@interface ZWVTweetAnnotation : MKPointAnnotation

@property (strong, nonatomic) ZWVTweet *tweet;

- (instancetype)initWithTweet:(ZWVTweet *)tweet;

@end