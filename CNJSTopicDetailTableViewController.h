//
//  CNJSTopicDetailTableViewController.h
//  CNodeJS_ios
//
//  Created by cheshire on 1/29/15.
//  Copyright (c) 2015 cheshire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicModel.h"

@interface CNJSTopicDetailTableViewController : UITableViewController <UIActionSheetDelegate>

@property (nonatomic,weak) NSString *topicId;
//@property (nonatomic,weak) NSString *topicContent;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *replyButtonItem;
- (IBAction)replyDidPressed:(id)sender;

@end
