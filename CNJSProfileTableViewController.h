//
//  CNJSProfileTableViewController.h
//  DNApp
//
//  Created by cheshire on 3/2/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CNJSProfileTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *avtarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userScore;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentTopicsLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentRepliesLabel;
@property (weak, nonatomic) IBOutlet UILabel *messagesLabel;

@end
