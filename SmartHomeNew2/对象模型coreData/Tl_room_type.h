//
//  Tl_room_type.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/25.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tl_room_type : NSManagedObject

@property (nonatomic, retain) NSString * roomtypeid;
@property (nonatomic, retain) NSString * roomname;
@property (nonatomic, retain) NSString * roomimg;
@property (nonatomic, retain) NSString * status;

@end
