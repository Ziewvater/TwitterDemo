//
//  ZWVTweetDisplayAnnotation.m
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/20/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import "ZWVTweetDetailsAnnotation.h"

@implementation ZWVTweetDetailsAnnotation

- (instancetype)initWithTweet:(ZWVTweet *)tweet {
    if (!(self = [super init])) return nil;
    if (!tweet) return nil;
    
    self.tweet = tweet;
    self.coordinate = tweet.location;
    
    return self;
}

@end

CGFloat MKPinAnnotationViewHeight = 39.0f;

@implementation ZWVTweetDetailsAnnotationView

- (instancetype)initWithTweetAnnotation:(ZWVTweetDetailsAnnotation *)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4.0f;
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    UILabel *tweetLabel = [[UILabel alloc] init];
    tweetLabel.numberOfLines = 0;
    tweetLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self addSubview:nameLabel];
    [self addSubview:tweetLabel];
    
    self.nameLabel = nameLabel;
    self.tweetTextLabel = tweetLabel;
    
    [self setAppearanceForTweetAnnotation:annotation];
    return self;
}

- (void)setAppearanceForTweetAnnotation:(ZWVTweetDetailsAnnotation *)annotation {
    NSDictionary *displayNameAttributes =   @{NSFontAttributeName : [UIFont boldSystemFontOfSize:[UIFont systemFontSize]]};
    NSDictionary *screenNameAttributes =    @{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]};
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:annotation.tweet.user.username
                                                                                   attributes:displayNameAttributes];
    [nameString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" @%@", annotation.tweet.user.screenName]
                                                                       attributes:screenNameAttributes]];
    self.nameLabel.attributedText = nameString;
    self.tweetTextLabel.text = annotation.tweet.text;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.centerOffset = CGPointMake(0, -(CGRectGetMidY(self.bounds) + MKPinAnnotationViewHeight));
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    if ([annotation isKindOfClass:[ZWVTweetDetailsAnnotation class]]) {
        [self setAppearanceForTweetAnnotation:(ZWVTweetDetailsAnnotation *)annotation];
    }
}

@end