//
//  BaseModel.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/19.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

//Json数据初始化
- (id)initWithContent:(NSDictionary *)json;

@end
