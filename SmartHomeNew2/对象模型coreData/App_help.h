//
//  App_help.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/6/4.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface App_help : NSManagedObject

@property (nonatomic, retain) NSString * helpid;
@property (nonatomic, retain) NSString *stitle;
@property (nonatomic, retain) NSString * helpdec;

@end
