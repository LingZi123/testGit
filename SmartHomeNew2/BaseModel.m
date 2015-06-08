//
//  BaseModel.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/19.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)initWithContent:(NSDictionary *)json
{
    
    self = [self init];
    
    if (self) {
        [self setModelData:json];
    }
    return self;
}

- (id)mapAttributes
{
    return nil;
}

- (SEL)setterMethod:(NSString *)key
{
    // 生成setter方法
    NSString *first = [[key substringToIndex:1] capitalizedString];
    NSString *end = [key substringFromIndex:1];
    
    NSString *setterName = [NSString stringWithFormat:@"set%@%@:",first,end];
    return NSSelectorFromString(setterName);
}// 生成setter方法


- (void)setModelData:(NSDictionary *)json
{
    NSDictionary *mapDic = [self mapAttributes];
    
    for (id key in mapDic) {
        
        // setter 方法
        SEL sel = [self setterMethod:key];
        
        if ([self respondsToSelector:sel]) {
            
            // 得到JSON key
            id jsonKey = [mapDic objectForKey:key];
            
            // 得到JSON value
            id jsonValue = [json objectForKey:jsonKey];
            
            // [self setTitle:@"title"];
            [self performSelector:sel withObject:jsonValue];
            
        }
        
    }
    
}// 属性赋值


@end
