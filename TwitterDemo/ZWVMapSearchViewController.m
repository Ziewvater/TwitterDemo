//
//  ZWVMapSearchViewController.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/20/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVMapSearchViewController.h"
#import "AppDelegate.h"
#import "ZWVTweet.h"
#import "ZWVTweetAnnotation.h"

@interface ZWVMapSearchViewController()
<MKMapViewDelegate>

@property (strong, nonatomic) NSArray *searchResults; // [ZWVTweet]

@end

@implementation ZWVMapSearchViewController

- (IBAction)findTweetsButtonTapped:(UIButton *)sender {
    [self findTweetsWithQuery:self.searchBar.text];
}

- (void)findTweetsWithQuery:(NSString *)query {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    __weak __typeof(self)weakSelf = self;
    NSString *mapGeocode = [self geocodeStringFromMap];
    [appDelegate.twitterAPI getSearchTweetsWithQuery:query ? query : @""
                                             geocode:mapGeocode
                                                lang:nil
                                              locale:nil
                                          resultType:nil
                                               count:nil
                                               until:nil
                                             sinceID:nil
                                               maxID:nil
                                     includeEntities:@NO
                                            callback:nil
                                        successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                            NSMutableArray *tweets = [NSMutableArray new];
                                            for (NSDictionary *dict in statuses) {
                                                [tweets addObject:[[ZWVTweet alloc] initWithDict:dict]];
                                            }
                                            weakSelf.searchResults = [tweets copy];
                                            [weakSelf showNewTweetResults];
                                        }
                                          errorBlock:^(NSError *error) {
                                              NSLog(@"Error searching tweets: %@", error);
                                          }];
}

/**
 Generates the Twitter geocode string for the map's current view.
 
 Ideally, the geocode string would define a rect that describes the current map
 view in the app, but Twitter's format only allows for a coodinate point and
 a radius. To use the entire area of the displayed map, we choose the larger
 dimension of the displayed map to define the search radius.
 
 @return geocode string to be used in Twitter's query
 */
- (NSString *)geocodeStringFromMap {
    CLLocationCoordinate2D mapCoordinate = self.mapView.centerCoordinate;
    
    // Find max map dimension for the current map view
    MKMapPoint nw = self.mapView.visibleMapRect.origin;
    MKMapPoint sw = MKMapPointMake(self.mapView.visibleMapRect.origin.x,
                                   self.mapView.visibleMapRect.origin.y +  self.mapView.visibleMapRect.size.height);
    MKMapPoint ne = MKMapPointMake(self.mapView.visibleMapRect.origin.x + self.mapView.visibleMapRect.size.width,
                                   self.mapView.visibleMapRect.origin.y);
    CLLocationDistance horizontalDistance = MKMetersBetweenMapPoints(nw, ne);
    CLLocationDistance verticalDistance = MKMetersBetweenMapPoints(nw, sw);
    CLLocationDistance maxDistance = MAX(horizontalDistance, verticalDistance);
    
    return [NSString stringWithFormat:@"%f,%f,%fkm", mapCoordinate.latitude, mapCoordinate.longitude, maxDistance/1000];
}

- (void)showNewTweetResults {
    // Remove existing tweets from map, show new ones
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    NSMutableArray *newAnnotations = [NSMutableArray new];
    for (ZWVTweet *tweet in self.searchResults) {
        ZWVTweetAnnotation *annotation = [[ZWVTweetAnnotation alloc] initWithTweet:tweet];
        [newAnnotations addObject:annotation];
    }
    [self.mapView addAnnotations:[newAnnotations copy]];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    NSString *identifier = @"tweet";
    MKPinAnnotationView *pin;
    MKAnnotationView *dequeuedView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if ([dequeuedView isKindOfClass:[MKPinAnnotationView class]]) {
        pin = (MKPinAnnotationView *)dequeuedView;
        pin.annotation = annotation;
    } else {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        pin.canShowCallout = YES;
    }
    return pin;
}

@end
