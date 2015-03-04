//
//  ReplyModel.m
//  CNodeJS
//
//  Created by cheshire on 12/3/14.
//  Copyright (c) 2014 cheshire. All rights reserved.
//

#import "ReplyModel.h"

@implementation ReplyModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    // model_property_name : json_field_name
    return @{
             @"reply_id" : @"id",
             @"author_loginname" : @"author.loginname",
             @"author_avatar_url" : @"author.avatar_url",
             @"reply_content" : @"content",
             @"replyCreateAt" : @"create_at", // tell Mantle to ignore this property
             @"ups" : @"ups"
             };
}

// mapping create_at to NSDate and vice-versa
+ (NSValueTransformer *)replyCreateAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateString) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSDateFormatter *)dateFormatter  {
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [[NSDateFormatter alloc] init];
        //dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    }
    return dateFormatter;
}


@end
