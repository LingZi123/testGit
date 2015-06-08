//
//  KeyChainOpr.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/31.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "KeyChainOpr.h"
#import "KeychainItemWrapper.h"

@implementation KeyChainOpr

-(NSString *) gen_uuid
{
//    CFUUIDRef uuid_ref=CFUUIDCreate(nil);
//    CFStringRef uuid_string_ref=CFUUIDCreateString(nil, uuid_ref);
//    CFRelease(uuid_ref);
//    NSString *uuid=[NSString stringWithString:uuid_string_ref];
//    CFRelease(uuid_string_ref);
//    return uuid;
    return @"001011203340567";
}
-(void) setKeyChainValue
{
    KeychainItemWrapper *keyChainItem=[[KeychainItemWrapper alloc]initWithIdentifier:@"Jianjun Wang" accessGroup:@"com.stone.SmartHomeNew2"];
    NSString *strUUID = [keyChainItem objectForKey:(id)kSecValueData];
    if (strUUID==nil||[strUUID isEqualToString:@""])
    {
        [keyChainItem setObject:[self gen_uuid] forKey:(id)kSecValueData];
    }
    [keyChainItem release];
    
}


@end
