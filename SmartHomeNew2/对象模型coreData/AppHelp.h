//
//  AppHelp.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/6/4.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "BaseModel.h"

@interface AppHelp : BaseModel

@property (nonatomic, retain) NSString * helpid;
@property (nonatomic, retain) NSString *stitle;
@property (nonatomic, retain) NSString * helpdec;

+(BOOL)AddHelp:(NSArray *)newHelpModelArrays;// 添加到本地数据库
+(NSArray *)queryAllHelp;// 查询所有数据

@end
