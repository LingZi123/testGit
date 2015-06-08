//
//  Tl_cuttomer_user.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/6/1.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tl_cuttomer_user : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * addtime;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * imeinum;
@property (nonatomic, retain) NSNumber * isLogout;
@property (nonatomic, retain) NSNumber * isRemeberPwd;
@property (nonatomic, retain) NSString * lastip;
@property (nonatomic, retain) NSDate * lasttime;
@property (nonatomic, retain) NSString * loginip;
@property (nonatomic, retain) NSString * parentid;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * truename;
@property (nonatomic, retain) NSString * userhead;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * userjob;
@property (nonatomic, retain) NSString * usermail;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * userpass;
@property (nonatomic, retain) NSString * userqq;
@property (nonatomic, retain) NSString * usersex;
@property (nonatomic, retain) NSString * usertel;

@end
