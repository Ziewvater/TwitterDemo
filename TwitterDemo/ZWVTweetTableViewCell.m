//
//  ZWVTweetTableViewCell.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/19/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVTweetTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZWVTweetTableViewCell

- (void)setUpWithTweet:(ZWVTweet *)tweet {
    if (tweet.user) {
        NSDictionary *displayNameAttributes =   @{NSFontAttributeName : [UIFont boldSystemFontOfSize:self.usernameLabel.font.pointSize]};
        NSDictionary *screenNameAttributes =    @{NSFontAttributeName : [UIFont systemFontOfSize:self.usernameLabel.font.pointSize]};
        NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:tweet.user.username
                                                                                       attributes:displayNameAttributes];
        [nameString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" @%@",tweet.user.screenName]
                                                                           attributes:screenNameAttributes]];
        self.usernameLabel.attributedText = [nameString copy];
    }
    if (tweet.text) {
        if (self.highlightPhrase) {
            // Find all the locations of the highlighted phrase
            NSMutableArray *locations = [NSMutableArray new];
            NSRange searchRange = NSMakeRange(0, [tweet.text length]);
            NSRange foundRange = [tweet.text rangeOfString:self.highlightPhrase options:NSCaseInsensitiveSearch range:searchRange];
            while (foundRange.location != NSNotFound) {
                [locations addObject:[NSValue valueWithRange:foundRange]];
                searchRange.location = foundRange.location + foundRange.length;
                searchRange.length = tweet.text.length - searchRange.location;
                foundRange = [tweet.text rangeOfString:self.highlightPhrase options:NSCaseInsensitiveSearch range:searchRange];
            }
            
            NSDictionary *highlightedAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:self.tweetTextLabel.font.pointSize]};
            NSDictionary *normalTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:self.tweetTextLabel.font.pointSize]};
            NSMutableAttributedString *tweetText = [[NSMutableAttributedString alloc] initWithString:tweet.text
                                                                                          attributes:normalTextAttributes];

            // Set bold font for all ranges of highlighted phrase
            for (NSValue *rangeValue in locations) {
                [tweetText setAttributes:highlightedAttributes range:[rangeValue rangeValue]];
            }
            self.tweetTextLabel.attributedText = tweetText;
        } else {
            self.tweetTextLabel.text = tweet.text;
        }
    }
    if (tweet.user.profileImageUrl) {
        self.avatarImageView.alpha = 0;
        __weak __typeof(self)weakSelf = self;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                           if (cacheType == SDImageCacheTypeMemory) {
                                               weakSelf.avatarImageView.alpha = 1;
                                           } else {
                                               [UIView animateWithDuration:0.2
                                                                animations:^{
                                                                    weakSelf.avatarImageView.alpha = 1;
                                                                }];
                                           }
                                       }];
    }
}

@end
