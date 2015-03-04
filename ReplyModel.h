//
//  ReplyModel.h
//  CNodeJS
//
//  Created by cheshire on 12/3/14.
//  Copyright (c) 2014 cheshire. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface ReplyModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong) NSString *reply_id;
@property (nonatomic,strong) NSString *author_loginname;
@property (nonatomic,strong) NSString *author_avatar_url;
@property (nonatomic,strong) NSString *reply_content;
@property (nonatomic,strong) NSDate   *replyCreateAt;
@property (nonatomic,strong) NSArray  *ups;

@end
