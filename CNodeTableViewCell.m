//
//  CNodeTableViewCell.m
//  DNApp
//
//  Created by cheshire on 2/21/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

#import "CNodeTableViewCell.h"



@implementation CNodeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
//    UILabel *textLabel = self.replyContentLabel;
//    UIColor *linkColor = [UIColor colorWithRed:0.203 green:0.309 blue:0.835 alpha:1];
//    UIColor *linkActiveColor = [UIColor blackColor];
//    
//    if([textLabel isKindOfClass:[TTTAttributedLabel class]]){
//        TTTAttributedLabel *label = (TTTAttributedLabel*)textLabel;
//        label.linkAttributes = @{NSForegroundColorAttributeName:linkColor,};
//        label.activeLinkAttributes = @{NSForegroundColorAttributeName:linkActiveColor,};
//        label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
//        label.delegate = self;
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
