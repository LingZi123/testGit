//
//  CottomerUser.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/19.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface CottomerUser :BaseModel

@property NSInteger UserId;//自增ID
@property(nonatomic,copy)NSString *UserTel;//用户手机
@property(nonatomic,copy)NSString *Imeinum;//手机IMEI
@property(nonatomic,copy)NSString *UserName;//用户昵称
@property(nonatomic,copy)NSString *UserPass;//登录密码
@property NSInteger ParentId;//上级ID默认为0无上级
@property(nonatomic,copy)NSString *UserMail;//用户邮箱
@property(nonatomic,copy)NSString *UserQQ;//用户QQ
@property(nonatomic,copy)NSString *Birthday;//用户生日
@property(nonatomic,copy)NSString *UserJob;//公司
@property(nonatomic,copy)NSString *UserHead;//头像
@property(nonatomic,copy)NSString *TrueName;//真是姓名
@property(nonatomic,copy)NSString *UserSex;//性别，0男，1女
@property(nonatomic,copy)NSString *Address;//常用地址
@property(nonatomic,copy)NSString *status;//0默认状态，1冻结，2删除
@property(nonatomic,retain)NSDate *AddTime;//添加时间
@property(nonatomic,retain)NSDate *LastTime;//更新时间
@property(nonatomic,copy)NSString *LoginIP;//登录IP
@property(nonatomic,copy)NSString *LastIP;//上次登录IP

@property(nonatomic)BOOL IsLogout;//是否注销登录
@property(nonatomic)BOOL IsRemeberPwd;//是否记住密码

+(CottomerUser *)getUserByDic:(NSDictionary *)dic;
+(BOOL)InsertUser:(CottomerUser *)userInfo;
+(NSInteger)Update:(CottomerUser *)userInfo;

@end
