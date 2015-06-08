//
//  CustomerRoom.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/6/2.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface CustomerRoom :BaseModel

@property (nonatomic, retain) NSString * roomid;
@property (nonatomic, retain) NSString * roomtype;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * roomname;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * addtime;
@property (nonatomic, retain) NSString * parentid;
@property (nonatomic, retain) NSString * adduserid;
@property (nonatomic, retain) NSString * upuserid;
@property (nonatomic, retain) NSDate * uptime;
@property (nonatomic, retain) NSString *roomImage;

@end
