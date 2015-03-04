//
//  CNJSManger.m
//  CNodeJS
//
//  Created by cheshire on 12/3/14.
//  Copyright (c) 2014 cheshire. All rights reserved.
//

#import "CNJSManger.h"
#import "CNJSClicent.h"
#import "TopicModel.h"
#import "UserModel.h"
#import "ACSimpleKeyChain.h"

@interface CNJSManger ()

@property (nonatomic, strong, readwrite) NSMutableArray *topics;
@property (nonatomic, strong, readwrite) NSMutableArray *hottopics;
@property (nonatomic, strong, readwrite) NSMutableArray *sharetopics;
@property (nonatomic, strong, readwrite) NSMutableArray *jobtopics;
@property (nonatomic, strong, readwrite) NSMutableArray *messages;
@property  (nonatomic, readwrite, strong) TopicModel *topic;
@property (nonatomic,strong, readwrite) UserModel *user;
@property (nonatomic,strong) NSString* currentUserName;
@property (nonatomic,strong) NSString* currentUserId;
@property (nonatomic,strong) NSString* currentToken;
@property (nonatomic,strong) CNJSClicent *client;

@end

@implementation CNJSManger

+(instancetype)sharedManager{
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (id)init{
    if( self = [super init]){
        _client = [[CNJSClicent alloc] init];
        
    }
    return self;
}

- (RACSignal *)getTopicsatPage:(int)page {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"all",@"tab",[NSString stringWithFormat:@"%d",page],@"page", [NSString stringWithFormat:@"%d", 15], @"limit",@"false",@"render",nil];
    return [[self.client getTopicsByParameters:params] doNext:^(NSArray *topics){
        self.topics = [NSMutableArray arrayWithArray:topics];
    }];
}

- (RACSignal *)getHotTopicsatPage:(int)page {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"good",@"tab", [NSString stringWithFormat:@"%d",page],@"page", [NSString stringWithFormat:@"%d", 15],@"limit",nil];
    return [[self.client getTopicsByParameters:params] doNext:^(NSArray *topics){
        self.hottopics = [NSMutableArray arrayWithArray:topics];;
    }];
}
- (RACSignal *)getJobTopicsatPage:(int)page {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"job",@"tab", [NSString stringWithFormat:@"%d",page],@"page", [NSString stringWithFormat:@"%d", 15],@"limit",nil];
    return [[self.client getTopicsByParameters:params] doNext:^(NSArray *topics){
        self.jobtopics = [NSMutableArray arrayWithArray:topics];;
    }];
}
- (RACSignal *)getShareTopicsatPage:(int)page {
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"share",@"tab", [NSString stringWithFormat:@"%d",page],@"page", [NSString stringWithFormat:@"%d", 15],@"limit",nil];
    return [[self.client getTopicsByParameters:params] doNext:^(NSArray *topics){
        self.sharetopics = [NSMutableArray arrayWithArray:topics];;
    }];
}

-(RACSignal*)getTopicDetailById:(NSString *)topicId{
    return [[self.client getTopicDetailById:topicId] doNext:^(TopicModel *topic){
        self.topic = topic;
    }];
}

- (RACSignal*)postToTopic:(NSString*)topicId withContent:(NSString*)content{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[self getAccessTokenFromKC],@"accesstoken", content,@"content", nil];
    return [self.client postToTopic:topicId withParameters:params];
}
- (RACSignal*)postToTopic:(NSString*)topicId atReplyId:(NSString*)replyId withContent:(NSString*)content{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[self getAccessTokenFromKC],@"accesstoken", content,@"content", replyId,@"reply_id", nil];
    return [self.client postToTopic:topicId withParameters:params];
}

- (RACSignal*)upVoteToReply:(NSString *)replyId{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:[self getAccessTokenFromKC],@"accesstoken", nil];
    return [self.client upVoteToReply:replyId withParameters:params];
}

- (RACSignal*)getUserInfoByName{
    //hard coded now
    return [self.client getUserInfoByName:self.currentUserName];
}

-(NSString*)getAccessTokenFromKC{
    ACSimpleKeychain *keychain = [ACSimpleKeychain defaultKeychain];
    NSDictionary *credentials = [keychain credentialsForUsername:@"token" service:@"CNodeJS"];
    return [credentials valueForKey:ACKeychainIdentifier];
    
}

//-(RACSignal*)buttonEnabledCheck{
//    RACSubject *tokenSubject = [RACSubject subject];
//    
//    RACSignal* combinedSignal =  [RACSignal combineLatest:@[tokenSubject]
//                             reduce:^(NSString* ctoken){
//                                 return @(ctoken.length > 0);
//                             }];
//    [tokenSubject sendNext:[self getAccessTokenFromKC]];
//    return combinedSignal;
//}

- (RACSignal*)checkAccessToken{
    //hard code now @"7c7e6f7f-2fc6-426c-a804-2dab5a0bb062"
    //fetch token from key chain
    ACSimpleKeychain *keychain = [ACSimpleKeychain defaultKeychain];
    NSDictionary *credentials = [keychain credentialsForUsername:@"token" service:@"CNodeJS"];
    NSString *token = [credentials valueForKey:ACKeychainIdentifier];
    if([token length] == 0 && [self.currentToken length] == 0) return [RACSignal empty];
    NSString *cToken = (token!=nil) ? token : self.currentToken;
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:cToken,@"accesstoken", nil];
    return [[self.client checkAccTokenWithParameters:params] doNext:^(NSDictionary *result){
        if([result valueForKey:@"success"]){
            //true
            self.currentUserName = [result valueForKey:@"loginname"];
            self.currentUserId   = [result valueForKey:@"id"];
            //store in key chain
            if(![token isEqualToString:cToken]){
                //ACSimpleKeychain *keychain = [ACSimpleKeychain defaultKeychain];
                if ([keychain storeUsername:@"token" password:@"" identifier:cToken forService:@"CNodeJS"]) {
                    NSLog(@"Saved token");
                }
            }
            
//            [[self getUserInfoByName] subscribeNext:^(UserModel* umodel){
//                self.user = umodel;
//            }];
        }
    }];
}


-(RACSignal*)setAccessTokenByQRScaner:(NSString *)result{
//    [RACObserve(self, currentToken) subscribeNext:^(NSString* token){
//        if(![token isEqualToString:self.currentToken]){
//            NSLog(@"set new token: %@",token);
//        }
//
//    }];
    self.currentToken = result;
    
    return [self checkAccessToken];
}

-(void)clearContents{
    self.currentToken = nil;
    self.currentUserId = nil;
    self.currentUserName = nil;
    self.user = nil;
    ACSimpleKeychain *keychain = [ACSimpleKeychain defaultKeychain];
    if([keychain deleteCredentialsForUsername:@"token" service:@"CNodeJS"]){
        NSLog(@"delete token for current user");
    }
}

@end
