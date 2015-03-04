//
//  UserModel.m
//  DNApp
//
//  Created by cheshire on 3/2/15.
//  Copyright (c) 2015 cheshire. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"loginName": @"loginname",
             @"avtarUrlString": @"avatar_url",
             @"recent_topics": @"recent_topics",
             @"recent_replies": @"recent_replies"
             };
}


@end
