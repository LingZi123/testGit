//
//  CottomerUser.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/19.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "CottomerUser.h"
#import "Tl_cuttomer_user.h"
#import <CoreData/CoreData.h>
#import "CommonDefine.h"


@implementation CottomerUser

- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"UserId":@"userid",
                             @"UserTel":@"usertel",
                             @"Imeinum":@"imeinum",
                             @"UserName": @"username",
                             
                             @"UserPass":@"userpass",
                             @"ParentId":@"parentid",
                             @"UserMail":@"usermail",
                             @"UserQQ":@"userqq",
                             @"Birthday":@"birthday",
                             
                             @"UserJob": @"userjob",
                             @"UserHead": @"userhead",
                             @"TrueName":@"truename",
                             @"UserSex":@"usersex",
                             
                             @"Address":@"address",
                             @"status":@"status",
                             @"AddTime": @"addtime",
                             @"LastTime": @"lasttime",
                             @"LoginIP":@"loginip",
                             @"LastIP":@"lastip",
                
                             };
    return mapDic;
}

+(BOOL)InsertUser:(CottomerUser *)userInfo{
    //注册成功，就写入本地数据库
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    
    
    Tl_cuttomer_user *newUser=[NSEntityDescription insertNewObjectForEntityForName:DE_Tl_cuttomer_user inManagedObjectContext:context];
    
    
    if (userInfo.UserId!=nil && userInfo.UserId!=(id)[NSNull null]) {
        NSString *userNSId=[NSString stringWithFormat:@"%@",userInfo.UserId ];
        [newUser setUserid: userNSId];
    }
    [newUser setUsertel:userInfo.UserTel];
    [newUser setUserpass:userInfo.UserPass];
    [newUser setUsername:userInfo.UserName];
    
    if (userInfo.ParentId!=nil&&userInfo.ParentId!=(id)[NSNull null]) {
        NSString *parentId=[NSString stringWithFormat:@"%@",userInfo.ParentId ];
        
        [newUser setParentid:parentId];
    }
    
    [newUser setUsermail:userInfo.UserMail];
    [newUser setUserqq:userInfo.UserQQ];
    [newUser setBirthday:userInfo.Birthday];
    [newUser setUserjob:userInfo.UserJob];
    [newUser setUserhead:userInfo.UserHead];
    [newUser setTruename:userInfo.TrueName];
    [newUser setUsersex:userInfo.UserSex];
    [newUser setAddress:userInfo.Address];
    [newUser setLasttime:[NSDate date]];
    [newUser setIsLogout:[NSNumber numberWithBool:userInfo.IsLogout]];
    [newUser setIsRemeberPwd:[NSNumber numberWithBool:userInfo.IsRemeberPwd]];
    
    NSError *error;
    if ([context save:&error]==YES) {
        NSLog(@"注册,保存本地数据库成功");
        return YES;
    }
    else{
        NSLog(@"注册保存本地数据错误 %@",error);
        return NO;
    }
}

+(CottomerUser *)getUserByDic:(NSDictionary *)dic{
    
    CottomerUser *newUser=nil;
    if (dic!=nil&&dic !=(id)[NSNull null]) {
        newUser=[[CottomerUser alloc]init];
        newUser.UserId=(NSInteger)[dic objectForKey:@"userid"];
        newUser.UserName=[dic objectForKey:@"username"];
        newUser.UserSex=[dic objectForKey:@"usersex"];
        newUser.UserTel=[dic objectForKey:@"usertel"];
    }
    return newUser;
}
+(NSInteger)Update:(CottomerUser *)userInfo{
    
    NSLog(@"%@",@"update");
    
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    
    //先查找
    NSFetchRequest *f=[NSFetchRequest fetchRequestWithEntityName:DE_Tl_cuttomer_user];
    
    f.predicate=[NSPredicate predicateWithFormat: @"usertel==%@",userInfo.UserTel];
    
    NSArray *excuteResult=[context executeFetchRequest:f error:nil];
    if (excuteResult==nil||excuteResult.count<=0)
    {
        NSLog(@"不存查找的对象");
        
        return 0;
    }
    //再修改
    for (Tl_cuttomer_user *tempUser in excuteResult) {
        if (![tempUser.usertel isEqualToString:userInfo.UserTel]) {
            continue;
        }
        else {
            
            
            if (![tempUser.username isEqualToString:userInfo.UserName]) {
                [tempUser setUsername:userInfo.UserName];
            }
            if (![tempUser.parentid  isEqualToString:[NSString stringWithFormat:@"%ld",(long)userInfo.ParentId]] ) {
                [tempUser setParentid:[NSString stringWithFormat:@"%ld",(long)userInfo.ParentId]];
            }
            if (![tempUser.usermail isEqualToString: userInfo.UserMail]) {
                [tempUser setUsermail:userInfo.UserMail];
            }
            if (![tempUser.userqq isEqualToString: userInfo.UserQQ]) {
                [tempUser setUserqq:userInfo.UserQQ];
            }
            if (![tempUser.birthday isEqualToString: userInfo.Birthday]) {
                [tempUser setBirthday:userInfo.Birthday];
            }
            if (![tempUser.userjob isEqualToString: userInfo.UserJob]) {
                [tempUser setUserjob:userInfo.UserJob];
            }
            if (![tempUser.userhead isEqualToString: userInfo.UserHead]) {
                [tempUser setUserhead:userInfo.UserHead];
            }
            if (![tempUser.truename isEqualToString: userInfo.TrueName]) {
                [tempUser setTruename:userInfo.TrueName];
            }
            if (![tempUser.usersex isEqualToString: userInfo.UserSex]) {
                [tempUser setUsersex:userInfo.UserSex];
            }
            if (![tempUser.address isEqualToString: userInfo.Address]) {
                [tempUser setAddress:userInfo.Address];
            }
            if ([tempUser.isLogout isEqualToNumber:[NSNumber numberWithBool:userInfo.IsLogout]]) {
                [tempUser setIsLogout:[NSNumber numberWithBool:userInfo.IsLogout]];
            }
            if ([tempUser.isRemeberPwd isEqualToNumber:[NSNumber numberWithBool:userInfo.IsRemeberPwd]]) {
                [tempUser setIsRemeberPwd:[NSNumber numberWithBool:userInfo.IsRemeberPwd]];
            }
            
            [tempUser setLasttime:[NSDate date]];
            
            break;
        }
    }
    //保存
    NSError *error=nil;
    if ([context save:&error]==NO) {
        NSLog(@"eoor %@",error);
        return 2;
    }
    else{
        NSLog(@"修改成功");
        return 1;
    }
}



@end
