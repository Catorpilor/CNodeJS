//
//  CNJSClicent.h
//  CNodeJS
//
//  Created by cheshire on 12/3/14.
//  Copyright (c) 2014 cheshire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CNJSClicent : NSObject

-(RACSignal*)getFromUrl:(NSString*)url withParameters:(NSDictionary*)parameters;
-(RACSignal*)postToUrl:(NSString*)url withParameters:(NSDictionary*)parameters;
-(RACSignal*)getTopicsByParameters:(NSDictionary*)params;
-(RACSignal*)getTopicDetailById:(NSString*)topicId;
-(RACSignal*)postToTopic:(NSString*)topicId withParameters:(NSDictionary*)parameters;
-(RACSignal*)upVoteToReply:(NSString*)replyId withParameters:(NSDictionary*)parameters;
//-(RACSignal*)postToTopic:(NSString*)topicId replyId:(NSString*) replyId withContent:(NSString*)content;
-(RACSignal*)getUserInfoByName:(NSString*)userName;
-(RACSignal*)checkAccTokenWithParameters:(NSDictionary*)parameters;

@end
