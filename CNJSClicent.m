//
//  CNJSClicent.m
//  CNodeJS
//
//  Created by cheshire on 12/3/14.
//  Copyright (c) 2014 cheshire. All rights reserved.
//

#import "CNJSClicent.h"
#import <AFNetworking.h>
#import "TopicModel.h"
#import "ReplyModel.h"
#import "UserModel.h"

@interface CNJSClicent ()

@property (nonatomic,strong) AFHTTPSessionManager *session;

@end

@implementation CNJSClicent


- (id)init{
    if (self = [super init]) {
        NSURL *baseUrl = [ NSURL URLWithString:@"https://cnodejs.org/api/v1"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl sessionConfiguration:config];
    }
    return self;
}

- (RACSignal*)getFromUrl:(NSString *)url withParameters:(NSDictionary *)parameters{
    
    NSLog(@"get %@", url);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *dataTask = [self.session GET:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary * object=(NSDictionary *)responseObject;
            //NSLog(@"response message: %@",object[@"data"]);
            [subscriber sendNext:object];
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"afnetwork error: %@",error);
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError* error){
        NSLog(@"error is :%@",error);
    }];
}

-(RACSignal*)postToUrl:(NSString*)url withParameters:(NSDictionary*)parameters{
    NSLog(@"POST %@", url);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *dataTask = [self.session POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary * object=(NSDictionary *)responseObject;
            //NSLog(@"response message: %@",object[@"data"]);
            [subscriber sendNext:object];
        }
                                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                        NSLog(@"afnetwork error: %@",error);
                                                        [subscriber sendError:error];
                                                    }];
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError* error){
        NSLog(@"error is :%@",error);
    }];
}

-(RACSignal*)getTopicsByParameters:(NSDictionary*)params{
    
    return [[self getFromUrl:@"/api/v1/topics" withParameters:params] map:^(NSDictionary *json) {
        // 2
        RACSequence *list = [json[@"data"] rac_sequence];

        return [[list map:^(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[TopicModel class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}

-(RACSignal*)getTopicDetailById:(NSString*)topicId{
    NSString *url = [NSString stringWithFormat:@"/api/v1/topic/%@",topicId];
    return [[self getFromUrl:url withParameters:nil] map:^(NSDictionary *json){
        return [MTLJSONAdapter modelOfClass:[TopicModel class] fromJSONDictionary:json[@"data"] error:nil];
    }];
}



-(RACSignal*)postToTopic:(NSString*)topicId withParameters:(NSDictionary*)parameters{
    NSString *url = [NSString stringWithFormat:@"/api/v1/topic/%@/replies",topicId];
    return [[self postToUrl:url withParameters:parameters] map:^(NSDictionary *json){
        return json;
    }];
}

-(RACSignal*)upVoteToReply:(NSString*)replyId withParameters:(NSDictionary*)parameters{
    NSString *url = [NSString stringWithFormat:@"/api/v1/reply/%@/ups",replyId];
    return [[self postToUrl:url withParameters:parameters] map:^(NSDictionary *json){
        return json;
    }];
}

-(RACSignal*)checkAccTokenWithParameters:(NSDictionary*)parameters{
    return [self postToUrl:@"/api/v1/accesstoken" withParameters:parameters];
}

-(RACSignal*)getUserInfoByName:(NSString*)userName{
    NSString *urlString = [NSString stringWithFormat:@"/api/v1/user/%@",userName];
    return [[self getFromUrl:urlString withParameters:nil] map:^(NSDictionary* json){
        return [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:json[@"data"] error:nil];
    }];
}



@end
