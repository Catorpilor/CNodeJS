//
//  CommentViewController.h
//  DNApp
//
//  Created by cheshire on 2/22/15.
//  Copyright (c) 2015 cheshire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postCommentButtonItem;
- (IBAction)postCommentDidPressed:(id)sender;
- (IBAction)cancelDidPressed:(id)sender;

@property (nonatomic,weak) NSString* topicId;
@property (nonatomic,weak) NSString* replyId;
@property (nonatomic,weak) NSString* authorName;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end
