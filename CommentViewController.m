//
//  CommentViewController.m
//  DNApp
//
//  Created by cheshire on 2/22/15.
//  Copyright (c) 2015 cheshire. All rights reserved.
//

#import "CommentViewController.h"
#import "CNJSManger.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"topicId:%@,replyId:%@",self.topicId,self.replyId);
    self.title = [NSString stringWithFormat:@"回复@%@",self.authorName];
    [self.commentTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)postComment:(NSString*)comment{
    RACCommand *getTopic = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input){
        if([self.replyId length] == 0 ){
            NSLog(@"topic reply");
            return [[CNJSManger sharedManager] postToTopic:self.topicId withContent:comment];
        }else{
            NSLog(@"comment reply");
            return [[CNJSManger sharedManager] postToTopic:self.topicId atReplyId:self.replyId withContent:[NSString stringWithFormat:@"@%@ %@",self.authorName, comment]];
        }
    }];
    [[getTopic.executionSignals flatten] subscribeNext:^(NSDictionary* result){
        //now seague to reveal view controller
        //[self performSegueWithIdentifier:@"showMain" sender:self];
        //        [self.topics addObjectsFromArray:topics];
        //        [self.tableView reloadData];
        //[self performSegueWithIdentifier:@"homeToDetail" sender:topic];
        if([result valueForKey:@"success"]){
            NSLog(@"post success");
            [self dismissViewControllerAnimated:YES completion:nil];
            //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"replyPosted" object:nil];
            NSDictionary *userinfo = @{@"reply_id":[result valueForKey:@"reply_id"],@"comment":comment};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"replyPosted" object:self userInfo:userinfo];
        }
    }];
    [getTopic execute:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)postCommentDidPressed:(id)sender {
    NSString* comment = self.commentTextView.text;
    [self postComment:comment];
}

- (IBAction)cancelDidPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
