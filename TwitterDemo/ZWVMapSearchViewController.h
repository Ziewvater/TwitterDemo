//
//  ZWVMapSearchViewController.h
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/20/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ZWVMapSearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *findTweetsButton;

- (IBAction)findTweetsButtonTapped:(UIButton *)sender;
@end
