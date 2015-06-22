//
//  ZWVMapSearchViewController.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/20/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVMapSearchViewController.h"
#import "ZWVTwitterHandler.h"
#import "ZWVTweet.h"
#import "ZWVTweetAnnotation.h"
#import "ZWVTweetDetailsAnnotation.h"

@interface ZWVMapSearchViewController()
<MKMapViewDelegate>

@property (strong, nonatomic) NSArray *searchResults; // [ZWVTweet]
@property (strong, nonatomic) ZWVTweetDetailsAnnotation *displayedDetails;

@end

@implementation ZWVMapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.placeholder = @"Filter results by text";
    
    // Style find tweets button to make visible over map
    self.findTweetsButton.backgroundColor = [UIColor whiteColor];
    self.findTweetsButton.layer.cornerRadius = 4.0f;
    self.findTweetsButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.findTweetsButton.layer.shadowOffset = CGSizeMake(0, 2);
    self.findTweetsButton.layer.shadowOpacity = 0.35f;
    
    // Center map on Portland
    MKCoordinateRegion initialRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(45.525, -122.67), 5000, 5000);
    [self.mapView setRegion:initialRegion];
}

- (IBAction)findTweetsButtonTapped:(UIButton *)sender {
    [self findTweetsWithQuery:self.searchBar.text];
}

- (void)findTweetsWithQuery:(NSString *)query {
    
    __weak __typeof(self)weakSelf = self;
    NSString *mapGeocode = [self geocodeStringFromMap];
    [[ZWVTwitterHandler shared].twitterAPI getSearchTweetsWithQuery:query ? query : @""
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
        annotation.highlightPhrase = self.searchBar.text;
        [newAnnotations addObject:annotation];
    }
    [self.mapView addAnnotations:[newAnnotations copy]];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self findTweetsWithQuery:searchBar.text];
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[ZWVTweetAnnotation class]]) {
        NSString *identifier = @"tweet";
        MKPinAnnotationView *pin;
        MKAnnotationView *dequeuedView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if ([dequeuedView isKindOfClass:[MKPinAnnotationView class]]) {
            pin = (MKPinAnnotationView *)dequeuedView;
            pin.annotation = annotation;
        } else {
            pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        return pin;
    } else if ([annotation isKindOfClass:[ZWVTweetDetailsAnnotation class]]) {
        NSString *identifier = @"tweetDetails";
        ZWVTweetDetailsAnnotationView *detailsView;
        MKAnnotationView *dequeuedView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if ([dequeuedView isKindOfClass:[ZWVTweetDetailsAnnotationView class]]) {
            detailsView = (ZWVTweetDetailsAnnotationView *)dequeuedView;
            detailsView.annotation = annotation;
        } else {
            detailsView = [[ZWVTweetDetailsAnnotationView alloc] initWithTweetAnnotation:(ZWVTweetDetailsAnnotation *)annotation reuseIdentifier:identifier];
        }
        return detailsView;
    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[ZWVTweetAnnotation class]]) {
        ZWVTweetAnnotation *tweetAnnotation = (ZWVTweetAnnotation *)view.annotation;
        ZWVTweetDetailsAnnotation *details = [[ZWVTweetDetailsAnnotation alloc] initWithTweet:tweetAnnotation.tweet];
        details.highlightPhrase = tweetAnnotation.highlightPhrase;
        __weak __typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [mapView addAnnotation:details];
            weakSelf.displayedDetails = details;
        });
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [mapView removeAnnotation:self.displayedDetails];
    self.displayedDetails = nil;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    // Dismiss keyboard. No other intuitive way offered yet.
    [self.searchBar resignFirstResponder];
}

@end
