//
//  CNJSHomeTableViewController.m
//  CNodeJS_ios
//
//  Created by cheshire on 1/28/15.
//  Copyright (c) 2015 cheshire. All rights reserved.
//

#import "CNJSHomeTableViewController.h"
#import "CNJSManger.h"
#import "TopicModel.h"
#import "CNodeTableViewCell.h"
#import "CNJSTopicDetailTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+TimeAgo.h"


@interface CNJSHomeTableViewController ()

@property (nonatomic,strong) NSMutableArray *topics;
@property (nonatomic) int cur_page;

@end

@implementation CNJSHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [self.refreshControl addTarget:self action:@selector(PullRefresh) forControlEvents:UIControlEventValueChanged];
    if(self.topics.count == 0){
        NSLog(@"get topics");
        [self PullRefresh];
    }
}


-(void)PullRefresh{
    RACCommand *refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[CNJSManger sharedManager] getTopicsatPage:1];
    }];
    [[refreshCommand.executionSignals flatten] subscribeNext:^(NSArray* topics){
        self.topics = [NSMutableArray arrayWithArray:topics];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];

    }];
    [refreshCommand execute:nil];
}

-(void)LoadMore{
    _cur_page = _cur_page + 1;
    RACCommand *loadMoreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input){
        return [[CNJSManger sharedManager] getTopicsatPage:self.cur_page];
    }];
    [[loadMoreCommand.executionSignals flatten] subscribeNext:^(NSArray* topics){
        [self.topics addObjectsFromArray:topics];
        [self.tableView reloadData];
    }];
    [loadMoreCommand execute:nil];
}

-(void)LoadTopicById:(NSString*)topicId{
    RACCommand *getTopic = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input){
        return [[CNJSManger sharedManager] getTopicDetailById:topicId];
    }];
    [[getTopic.executionSignals flatten] subscribeNext:^(TopicModel* topic){
        [self performSegueWithIdentifier:@"homeToDetail" sender:topic];
    }];
    [getTopic execute:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"homeToDetail"]){
        CNJSTopicDetailTableViewController *detailViewController = segue.destinationViewController;
        TopicModel* model = (TopicModel*)sender;
        detailViewController.topicId = model.topic_id;
        //detailViewController.topicContent = model.content;
    }
    
}

#pragma mark - private method
-(void)configureCell:(CNodeTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath{
    TopicModel *topic = [self.topics objectAtIndex:indexPath.row];
    cell.topicAuthorLabel.text = topic.author_loginname;
    cell.topicTitleLabel.text = topic.title;
    cell.topicVisitLabel.text = [topic.visit_count stringValue];
    cell.topicCommentLabel.text = [topic.reply_count stringValue];
    if(![topic.author_avatar_url hasPrefix:@"http"]){
        topic.author_avatar_url = [NSString stringWithFormat:@"http:%@",topic.author_avatar_url];
    }
    [cell.authorAvatarImageView setImageWithURL:[NSURL URLWithString:topic.author_avatar_url]];
    cell.topicDateLabel.text = [topic.topicCreateAt timeAgoSimple];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.topics count];
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"%ld",indexPath.row);
    
    CNodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topicCell" forIndexPath:indexPath];

    
     //Configure the cell...
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexpath.row is %ld",(long)indexPath.row);
    TopicModel *model =[self.topics objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"homeToDetail" sender:model];
}




@end
