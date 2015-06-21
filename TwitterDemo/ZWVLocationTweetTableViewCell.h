//
//  ZWVLocationTweetTableViewCell.h
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVTweetTableViewCell.h"

/**
 A table view cell that displays a tweet with a location.
 */
@interface ZWVLocationTweetTableViewCell : ZWVTweetTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;

@end
