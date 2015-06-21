//
//  ZWVTweet.h
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ZWVUser.h"

/**
 Represents a single status update from Twitter.
 */
@interface ZWVTweet : NSObject

/// Date string for when the tweet was posted.
@property (strong, nonatomic) NSString *createdDateString;
/// Body text of the tweet.
@property (strong, nonatomic) NSString *text;

/// Location the tweet originated from. Check `-hasLocation` before using this property.
@property (nonatomic) CLLocationCoordinate2D location;

/// User that posted the tweet.
@property (strong, nonatomic) ZWVUser *user;

/// Creates and returns a ZWVTweet object with JSON returned from the server.
- (instancetype)initWithDict:(NSDictionary *)jsonDict;

/**
 Calculates whether or not the tweet has a valid location associated with it.
 Note that tweets originating from lat: 0, long: 0 will be falsely reported as
 having no location, but it's pretty unlikely we're gonna get any from there.
 */
- (BOOL)hasLocation;

/**
 Gives access to a map image for the given tweet's location. If the map image
 being requested has been fetched before, this method returns a stored version
 of that same image.
 
 Use this method to prevent multiple calls for the same image. Useful for table
 views where scrolling back and forth can cause jittery appearance with map
 images being loaded asynchronously.

 @param size              Size for the map snapshot image
 @param latitudeDistance  Latitudinal distance for the map snapshot image
 @param longitudeDistance Longitudinal distance for the map snapshot image
 @param completion        Block that gives access to the requested map image, or an
 error if something goes wrong.
 */
- (void)mapImageForLocationWithSize:(CGSize)size latitudeDistance:(CLLocationDistance)latitudeDistance longitudeDistance:(CLLocationDistance)longitudeDistance completion:(void (^)(UIImage *mapImage, NSError *error))completion;

@end
