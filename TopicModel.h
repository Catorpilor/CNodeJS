//
//  TopicModel.h
//  CNodeJS
//
//  Created by cheshire on 12/3/14.
//  Copyright (c) 2014 cheshire. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface TopicModel : MTLModel <MTLJSONSerializing>

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


//property

@property (nonatomic,strong) NSString *topic_id;
@property (nonatomic,strong) NSString *author_id;
@property (nonatomic,strong) NSString *tab;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSDate   *topicCreateAt;
@property (nonatomic,strong) NSNumber *reply_count;
@property (nonatomic,strong) NSNumber *visit_count;
@property (nonatomic,getter=isGood) BOOL      good;
@property (nonatomic,getter=isTop)  BOOL      top;
@property (nonatomic,strong) NSString *author_loginname;
@property (nonatomic,strong) NSString *author_avatar_url;
@property (nonatomic,strong) NSArray  *replies;
@property (nonatomic,strong) NSDate   *lastReplyAt;



@end
