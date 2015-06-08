//
//  Tl_customer_room.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/25.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tl_customer_room : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * roomtype;
@property (nonatomic, retain) NSNumber * userid;
@property (nonatomic, retain) NSString * roomname;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * addtime;
@property (nonatomic, retain) NSNumber * parentid;
@property (nonatomic, retain) NSNumber * adduserid;
@property (nonatomic, retain) NSNumber * upuserid;
@property (nonatomic, retain) NSDate * uptime;

@end
