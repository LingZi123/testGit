//
//  RoomType.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/6/2.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface RoomType :BaseModel

@property (nonatomic,retain) NSString *roomtypeid;
@property (nonatomic, retain) NSString * roomname;
@property (nonatomic, retain) NSString * roomimg;
@property (nonatomic, retain) NSString * status;


@end
