//
//  CNodeTableViewCell.h
//  DNApp
//
//  Created by cheshire on 2/21/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNodeTableViewCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UIImageView *topicTabImageView;
@property (weak, nonatomic) IBOutlet UILabel *topicTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicVisitLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicCommentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentImageVIew;
@property (weak, nonatomic) IBOutlet UIImageView *visitImageView;
@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *topicContent;
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *upteVoteImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentUpvoteLabel;
@end
