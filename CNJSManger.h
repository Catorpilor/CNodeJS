//
//  CNJSManger.h
//  CNodeJS
//
//  Created by cheshire on 12/3/14.
//  Copyright (c) 2014 cheshire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@class TopicModel;
@class UserModel;

@interface CNJSManger : NSObject

+(instancetype) sharedManager;

//properties
@property (nonatomic, readonly, strong) NSMutableArray *topics;
@property (nonatomic, readonly, strong) NSMutableArray *hottopics;
@property (nonatomic, readonly, strong) NSMutableArray *sharetopics;
@property (nonatomic, readonly, strong) NSMutableArray *jobtopics;
@property (nonatomic, readonly, strong) NSMutableArray *messages;
@property  (nonatomic, readonly, strong) TopicModel *topic;

- (RACSignal *)getTopicsatPage:(int)page;
- (RACSignal *)getHotTopicsatPage:(int)page;
- (RACSignal *)getJobTopicsatPage:(int)page;
- (RACSignal *)getShareTopicsatPage:(int)page;
- (RACSignal*)getTopicDetailById:(NSString*)topicId;
- (RACSignal*)postToTopic:(NSString*)topicId withContent:(NSString*)content;
- (RACSignal*)postToTopic:(NSString*)topicId atReplyId:(NSString*)replyId withContent:(NSString*)content;
- (RACSignal*)upVoteToReply:(NSString*)replyId;
- (RACSignal*)getUserInfoByName;
- (RACSignal*)checkAccessToken;
- (RACSignal*)setAccessTokenByQRScaner:(NSString*)result;
- (NSString*)getAccessTokenFromKC;
- (void)clearContents;



@end
