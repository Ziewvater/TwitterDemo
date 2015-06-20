//
//  ZWVTweet.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVTweet.h"
#import <MapKit/MapKit.h>

NSString * const ZWVTweetAttributeUser = @"user";
NSString * const ZWVTweetAttributeText = @"text";
NSString * const ZWVTweetAttributeCoordinates = @"coordinates";

@interface ZWVTweet ()

@property (nonatomic) CGSize storedMapSnapshotSize;
@property (strong, nonatomic) UIImage *storedMapSnapshotImage;

@end

@implementation ZWVTweet

- (instancetype)initWithDict:(NSDictionary *)jsonDict {
    if (!(self = [super init])) return nil;
    if (!jsonDict) return nil; // No dict, return nothing
    
    if (jsonDict[ZWVTweetAttributeText]) {
        self.text = jsonDict[ZWVTweetAttributeText];
    }
    if (jsonDict[ZWVTweetAttributeCoordinates] && jsonDict[ZWVTweetAttributeCoordinates] != [NSNull null]) {
        NSArray *coordinateArray = jsonDict[ZWVTweetAttributeCoordinates][@"coordinates"];
        // Twitter puts longitude first, then latitude.
        NSNumber *longitude = (NSNumber *)[coordinateArray objectAtIndex:0];
        NSNumber *latitude = (NSNumber *)[coordinateArray objectAtIndex:1];
        self.location = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
    }
    if (jsonDict[ZWVTweetAttributeUser]) {
        self.user = [[ZWVUser alloc] initWithDict:jsonDict[ZWVTweetAttributeUser]];
    }
    
    return self;
}

- (BOOL)hasLocation {
    // 'nil' locations will be initialized with (lat, long) of (0,0)
    return (self.location.longitude == 0 && self.location.latitude == 0) ? NO : YES;
}

- (void)mapImageForLocationWithSize:(CGSize)size latitudeDistance:(CLLocationDistance)latitudeDistance longitudeDistance:(CLLocationDistance)longitudeDistance completion:(void (^)(UIImage *, NSError *))completion {
    
    if (self.storedMapSnapshotImage && CGSizeEqualToSize(self.storedMapSnapshotSize, size)) {
        // If there's a stored map image with the same options, return that image
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self.storedMapSnapshotImage, nil);
        });
    } else {
        self.storedMapSnapshotSize = size; // Store for later comparison
        MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
        options.region = MKCoordinateRegionMakeWithDistance(self.location, latitudeDistance, longitudeDistance);
        options.showsPointsOfInterest = NO;
        options.size = size;
        __weak __typeof(self)weakSelf = self;
        MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
        [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
            if (snapshot) {
                weakSelf.storedMapSnapshotImage = snapshot.image;
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(snapshot.image, nil);
                    });
                }
            } else if (error) {
                NSLog(@"Error creating map snapshot for tweet: %@", weakSelf);
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, error);
                    });
                }
            }
        }];
    }
}

@end
