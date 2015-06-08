//
//  CustomerRoom.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/6/2.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "CustomerRoom.h"

@implementation CustomerRoom
- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"roomid":@"id",
                             @"roomtype":@"roomtype",
                             @"roomname":@"roomname",
                             @"roomImage":@"roomimg",

                             
                             };
    return mapDic;
}


@end
