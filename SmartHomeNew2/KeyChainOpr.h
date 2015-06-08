//
//  KeyChainOpr.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/31.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainOpr : NSObject
-(NSString *) gen_uuid;
-(void) setKeyChainValue;
@end
