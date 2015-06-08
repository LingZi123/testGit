//
//  RoomType.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/6/2.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "RoomType.h"

@implementation RoomType

- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"roomtypeid":@"id",
                             @"roomname":@"name",
                             @"roomimg":@"img",
                            };
    return mapDic;
}


@end
