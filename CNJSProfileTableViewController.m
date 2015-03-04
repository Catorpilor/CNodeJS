//
//  CNJSProfileTableViewController.m
//  DNApp
//
//  Created by cheshire on 3/2/15.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

#import "CNJSProfileTableViewController.h"
#import "CNJSManger.h"
#import "UserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CNJSProfileTableViewController ()

@property (nonatomic,strong) UserModel* curUser;


@end

@implementation CNJSProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.curUser = [[CNJSManger sharedManager] getUser];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //[self configureCellsByLogStatus:(self.curUser!=nil)];
    //[self getUserInfo];
//    @weakify(self);
//    [RACObserve(self, curUser) subscribeNext:^(id x){
//        @strongify(self);
//        [self configureCellsByLogStatus:(self.curUser!=nil)];
//    }];
//    [self getUserInfo];
    
    
}

-(void)getUserInfo{
    [[[CNJSManger sharedManager] getUserInfoByName] subscribeNext:^(UserModel* userinfo){
        self.curUser = userinfo;
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    @weakify(self);
    [RACObserve(self, curUser) subscribeNext:^(id x){
        @strongify(self);
        [self configureCellsByLogStatus:(self.curUser!=nil)];
    }];
    [self getUserInfo];
    
    //get userinfo
    
}

-(void)configureCellsByLogStatus:(BOOL)blogged{
    if(blogged){
        if(![self.curUser.avtarUrlString hasPrefix:@"http"]){
            self.curUser.avtarUrlString = [NSString stringWithFormat:@"http:%@",self.curUser.avtarUrlString];
        }
        [self.avtarImageView setImageWithURL:[NSURL URLWithString:self.curUser.avtarUrlString]];
        self.userName.text = self.curUser.loginName;
        self.userScore.text = [self.curUser.score stringValue];
        self.statusLabel.text = @"登出";
        self.userName.enabled = true;
        self.userScore.enabled = true;
        self.recentTopicsLabel.enabled = true;
        self.recentRepliesLabel.enabled = true;
        self.messagesLabel.enabled = true;
    }else{
        self.userName.text = nil;
        self.userScore.text = nil;
        self.avtarImageView.image = nil;
        self.userName.enabled = false;
        self.userScore.enabled = false;
        self.recentTopicsLabel.enabled = false;
        self.recentRepliesLabel.enabled = false;
        self.messagesLabel.enabled = false;
        self.statusLabel.text = @"登入";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2){
        if([self.statusLabel.text isEqualToString:@"登出"]){
            //[self.tabBarController setSelectedIndex:0];
            //logout action
            [[CNJSManger sharedManager] clearContents];
            [self configureCellsByLogStatus:false];
            self.statusLabel.text = @"登入";
        }else{
            //show the qr scan view
            [self performSegueWithIdentifier:@"toLoginScene" sender:self];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}


@end
