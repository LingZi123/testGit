//
//  AppDelegate.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/19.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CottomerUser.h"
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,LoginViewControllerDelegate,NSURLConnectionDataDelegate>{
    NSMutableData *_mData;//网络数据
    CommandType _command;//操作命令
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navController;//导航试图


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(nonatomic,strong,retain)CottomerUser *userInfo;//用户信息
@property(nonatomic,retain)NSArray *roomTypes;//房间类型
@property(nonatomic,retain)NSArray *deviceTypes;//设备类型

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(NSString *)VertyTel:(NSString *)tel;// 验证手机号
-(NSString *)VertyPassword:(NSString *)fieldText;//验证手机号
-(NSString *)localIPAddress;// 登录IP

//组装提交数据
-(NSData *)postDataWithRet:(NSString *)ret uid:(NSString *)uid data:(NSDictionary *)data time:(NSString *)time sign:(NSString *)sign;
//获取错误信息
-(NSString *)getErrorMesByRet:(NSString *)ret;

//时间转换为string
-(NSString *)getCurrentTimeByDate:(NSDate *)date;
-(NSString *)getAppVersion;//获取应用程序版本号
-(NSString *)getRet;// 获取ret
-(NSString *)getRoomImageWithRoomtype:(NSString *)roomType;//获取房间图片
-(NSString *)getCurrentDate:(NSDate *)date;
@end


