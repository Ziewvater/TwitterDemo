//
//  ZWVSearchViewController.h
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Users can search for tweets by text query using this view.
 */
@interface ZWVSearchViewController : UIViewController
<
UISearchBarDelegate
>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
