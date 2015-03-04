//
//  UserModel.h
//  DNApp
//
//  Created by cheshire on 3/2/15.
//  Copyright (c) 2015 cheshire. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle.h>

@interface UserModel : MTLModel <MTLJSONSerializing>

@property (nonatomic,strong) NSString* loginName;
@property (nonatomic,strong) NSString* avtarUrlString;
@property (nonatomic,strong) NSNumber* score;
@property (nonatomic,strong) NSArray*  recent_topics;
@property (nonatomic,strong) NSArray*  recent_replies;


@end
