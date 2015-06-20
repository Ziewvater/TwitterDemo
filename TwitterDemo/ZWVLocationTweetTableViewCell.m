//
//  ZWVLocationTweetTableViewCell.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVLocationTweetTableViewCell.h"
#import <MapKit/MapKit.h>

CLLocationDistance ZWVDefaultRegionDistance = 10000;

@implementation ZWVLocationTweetTableViewCell

- (void)setUpWithTweet:(ZWVTweet *)tweet {
    [super setUpWithTweet:tweet];
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = MKCoordinateRegionMakeWithDistance(tweet.location, ZWVDefaultRegionDistance, ZWVDefaultRegionDistance);
    options.showsPointsOfInterest = NO;
    options.size = self.mapImageView.frame.size;
    
    __weak __typeof(self)weakSelf = self;
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        if (snapshot) {
            weakSelf.mapImageView.image = snapshot.image;
        } else if (error) {
            NSLog(@"Error creating map snapshot for tweet: %@", tweet);
        }
    }];
}

@end
