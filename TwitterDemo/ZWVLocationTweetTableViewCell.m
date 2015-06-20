//
//  ZWVLocationTweetTableViewCell.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVLocationTweetTableViewCell.h"

CLLocationDistance ZWVDefaultRegionDistance = 10000;

@implementation ZWVLocationTweetTableViewCell

- (void)setUpWithTweet:(ZWVTweet *)tweet {
    [super setUpWithTweet:tweet];
    
    __weak __typeof(self)weakSelf = self;
    [tweet mapImageForLocationWithSize:self.mapImageView.frame.size
                      latitudeDistance:ZWVDefaultRegionDistance
                     longitudeDistance:ZWVDefaultRegionDistance
                            completion:^(UIImage *mapImage, NSError *error) {
                                if (mapImage) {
                                    weakSelf.mapImageView.image = mapImage;
                                }
                            }];
}

@end
