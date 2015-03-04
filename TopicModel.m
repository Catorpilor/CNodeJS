//
//  TopicModel.m
//  CNodeJS
//
//  Created by cheshire on 12/3/14.
//  Copyright (c) 2014 cheshire. All rights reserved.
//

#import "TopicModel.h"
#import "ReplyModel.h"

//topic JSON format
//{ data: { id : NSString,
//          author_id: NSString,
//          tab: NSString,
//          content: NSString,
//          title: NSString,
//          last_reply_at: NSDate,
//          good: bool,
//          top: bool,
//          reply_count: NSNumber,
//          visit_count: NSNumber,
//          create_at : NSDate,
//          author: {
//              loginname: NSString,
//              avatar_url: NSString
//          },
//          replies:[{
//              id: NSString,
//              author:{
//                  loginname: NSString,
//                  avatar_url: NSString
//              },
//              content: NSString,
//              ups: [],
//              create_at: NSDate
//          }]
//}}
//

@implementation TopicModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"topic_id": @"id",
             @"author_id": @"author_id",
             @"tab": @"tab",
             @"content": @"content",
             @"title": @"title",
             @"author_loginname": @"author.loginname",
             @"author_avatar_url": @"author.avatar_url",
             @"topicCreateAt":@"create_at",
             @"lastReplyAt":@"last_reply_at"
             };
}

// mapping create_at to NSDate and vice-versa
+ (NSValueTransformer *)topicCreateAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateString) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)lastReplyAtJSONTransformer {
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

+ (NSValueTransformer *)goodJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)topJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

//replies convertor
+ (NSValueTransformer *)repliesJSONTransformer
{
    // tell Mantle to populate appActions property with an array of ChoosyAppAction objects
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[ReplyModel class]];
}




@end
