//
//  CNJSTopicDetailTableViewController.m
//  CNodeJS_ios
//
//  Created by cheshire on 1/29/15.
//  Copyright (c) 2015 cheshire. All rights reserved.
//

#import "CNJSTopicDetailTableViewController.h"
#import "CNodeTableViewCell.h"
#import "CNJSManger.h"
#import "TopicModel.h"
#import "ReplyModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+TimeAgo.h"
#import "CommentViewController.h"


@interface CNJSTopicDetailTableViewController ()

@property (nonatomic,strong) TopicModel *topic;
@property (nonatomic) NSInteger currentClickIndex;
@property (nonatomic,strong) CNodeTableViewCell* prototypeCell;
//@property (strong, nonatomic) NSMutableDictionary *offscreenCells;

@end

@implementation CNJSTopicDetailTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@",self);
    NSLog(@"remove observer from viewWillAppear");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"replyPosted" object:nil];
    NSLog(@"add observer from viewWillAppear");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewComment:) name:@"replyPosted" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"%@",self.navigationController.viewControllers);
    //to check currentVC in navigation stack or not
    if([self.navigationController.viewControllers indexOfObject:self] == NSNotFound){
        NSLog(@"remove observer from viewWillDisappear");
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"replyPosted" object:nil];
    }
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewComment:) name:@"replyPosted" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentClickIndex = -1;
    [self LoadTopicById:self.topicId];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma private method

-(void)addNewComment:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"replyPosted"])
    {
        NSDictionary* userInfo = notification.userInfo;
        //NSNumber* total = (NSNumber*)userInfo[@"total"];
        NSLog (@"Successfully received test notification! %@",[userInfo valueForKey:@"reply_id"]);
        
        //save my ass
        [self LoadTopicById:self.topicId];
    }
}

-(void)LoadTopicById:(NSString*)topicId{
    RACCommand *getTopic = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input){
        return [[CNJSManger sharedManager] getTopicDetailById:topicId];
    }];
    [[getTopic.executionSignals flatten] subscribeNext:^(TopicModel* topic){
        self.topic = topic;
        [self.tableView reloadData];
    }];
    [getTopic execute:nil];
    
}

-(void)upvoteReply{
    RACCommand *upvoteReply = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input){
        return [[CNJSManger sharedManager] upVoteToReply:[[self.topic.replies objectAtIndex:self.currentClickIndex] valueForKey:@"reply_id"]];
    }];
    [[upvoteReply.executionSignals flatten] subscribeNext:^(NSDictionary* result){
        if([result valueForKey:@"success"]){
            //check action status
            CNodeTableViewCell *cell = (CNodeTableViewCell*)[self.tableView cellForRowAtIndexPath: [self.tableView indexPathForSelectedRow]];
            if([[result valueForKey:@"action"] isEqualToString:@"up"]){
                //ups
                cell.commentUpvoteLabel.text = [NSString stringWithFormat:@"%d", [cell.commentUpvoteLabel.text intValue]+1];
            }else{
                //downs
                cell.commentUpvoteLabel.text = [NSString stringWithFormat:@"%d", [cell.commentUpvoteLabel.text intValue]-1];
            }
        }
    }];
    [upvoteReply execute:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"detailToComment"]){
        TopicModel *topic = sender;
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        CommentViewController *commentViewC = (CommentViewController*)[navController topViewController];
        commentViewC.topicId = topic.topic_id;
        if(self.currentClickIndex>=0){
            commentViewC.replyId = [[topic.replies objectAtIndex:self.currentClickIndex] valueForKey:@"reply_id"];
            commentViewC.authorName = [[topic.replies objectAtIndex:self.currentClickIndex] valueForKey:@"author_loginname"];
        }else{
            commentViewC.authorName = self.topic.author_loginname;
            commentViewC.replyId = nil;
        }
    }
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"Reply"]){
        [self performSegueWithIdentifier:@"detailToComment" sender:self.topic];
    }
    if([buttonTitle isEqualToString:@"Star"]){
        //do somethings
        [self upvoteReply];
    }
}

#pragma mark - private method

-(NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath{
    if(indexPath.row == 0){
        return @"topicCell";
    }
    return @"replyCell";
}

-(void)configureCell:(CNodeTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath offScreen:(BOOL)bOff{
    if(indexPath.row == 0){
        cell.topicTitleLabel.text = self.topic.title;
        cell.topicAuthorLabel.text = self.topic.author_loginname;
        cell.topicTitleLabel.text = self.topic.title;
        cell.topicVisitLabel.text = [self.topic.visit_count stringValue];
        cell.topicCommentLabel.text = [self.topic.reply_count stringValue];
        if(![self.topic.author_avatar_url hasPrefix:@"http"]){
            self.topic.author_avatar_url = [NSString stringWithFormat:@"http:%@",self.topic.author_avatar_url];
        }
        [cell.authorAvatarImageView setImageWithURL:[NSURL URLWithString:self.topic.author_avatar_url]];
//        NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
//        NSAttributedString *preview = [[NSAttributedString alloc] initWithString:self.topic.content attributes:options];
        //cell.topicContent.text = self.topic.content;
        if(bOff){
            NSString *encodedString = [NSString stringWithFormat:@"<meta charset=\"UTF-8\"><div style='font-size: 15px; font-family: HelveticaNeue;'>%@</div>",self.topic.content];
            NSDictionary *attribs = @{
                                      NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                      NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:18] //did not work
                                      };
            NSAttributedString *attrString =        [[NSAttributedString alloc]
                                                     initWithData: [encodedString dataUsingEncoding:NSUTF8StringEncoding]
                                                     options: attribs
                                                     documentAttributes: nil
                                                     error: nil];
            //NSLog(@"%@",attrString);
            cell.topicContent.attributedText = attrString;
        }else{
            cell.topicContent.text = self.topic.content;
        }
        
        cell.topicDateLabel.text = [self.topic.topicCreateAt timeAgoSimple];
        //cell.topicContent.attributedText = preview;
        //NSLog(@"%@",self.topic.content);
    }else{
        ReplyModel *reply = [self.topic.replies objectAtIndex:indexPath.row-1];
        cell.topicAuthorLabel.text = reply.author_loginname;
        cell.commentUpvoteLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[reply.ups count]];
        //cell.topicContent.text = reply.reply_content;
        if(![self.topic.author_avatar_url hasPrefix:@"http"]){
            self.topic.author_avatar_url = [NSString stringWithFormat:@"http:%@",reply.author_avatar_url];
        }
        
        //cell.replyContentLabel.text = reply.reply_content;
        if(bOff){
            NSString *encodedString = [NSString stringWithFormat:@"<meta charset=\"UTF-8\"><div style='font-size: 14px; font-family: HelveticaNeue;'>%@</div>",reply.reply_content];
            NSDictionary *attribs = @{
                                      NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                      NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:15] //did not work
                                      };
            NSAttributedString *attrString =        [[NSAttributedString alloc]
                                                     initWithData: [encodedString dataUsingEncoding:NSUTF8StringEncoding]
                                                     options: attribs
                                                     documentAttributes: nil
                                                     error: nil];
            cell.replyContentLabel.attributedText = attrString;
        }else{
            cell.replyContentLabel.text = reply.reply_content;
        }
        
        [cell.authorAvatarImageView setImageWithURL:[NSURL URLWithString:reply.author_avatar_url]];
        cell.topicDateLabel.text = [reply.replyCreateAt timeAgoSimple];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"%ld",indexPath.row);
    if(indexPath.row == 0){
        self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForIndexPath:indexPath]];
        [self configureCell:self.prototypeCell forIndexPath:indexPath offScreen:TRUE];
        //[self.prototypeCell layoutIfNeeded];
        CGFloat height = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        self.prototypeCell = nil;
        return height+1.0f;
    }
    if(!self.prototypeCell){
        self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForIndexPath:indexPath]];
    }
    [self configureCell:self.prototypeCell forIndexPath:indexPath offScreen:TRUE];
    //[self.prototypeCell layoutIfNeeded];
    CGFloat height = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height+1.0f;
//    CNodeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForIndexPath:indexPath]];
//    [self configureCell:cell forIndexPath:indexPath];
////    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
//    //[cell layoutIfNeeded];
//    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    //NSLog(@"cellheight: %f",height);
//    return height+1.0f;//1.0f stands for seperator line
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.topic.replies count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    CNodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForIndexPath:indexPath]];
    [self configureCell:cell forIndexPath:indexPath offScreen:TRUE];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexpath.row is %ld",(long)indexPath.row);
    //TopicModel *model =[self.topics objectAtIndex:indexPath.row];
    //[self performSegueWithIdentifier:@"homeToDetail" sender:model.topic_id];
    if(indexPath.row != 0){
        //just the reply cells
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Close" destructiveButtonTitle:nil otherButtonTitles:@"Reply",@"Star", nil];
        [actionSheet showInView:self.view];
        self.currentClickIndex = indexPath.row-1;
    }
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)replyDidPressed:(id)sender {
    self.currentClickIndex = -1;
    [self performSegueWithIdentifier:@"detailToComment" sender:self.topic];
}

@end
