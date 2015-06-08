//
//  AppDelegate.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/19.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "CommonDefine.h"
#import "KeychainItemWrapper.h"
#import <Security/SecItem.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include "JsonToModel.h"
#import "KeyChainOpr.h"
#import "UIWindow+YzdHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    BOOL firtLoad=[[NSUserDefaults standardUserDefaults]
                    boolForKey:@"firstStart"];
    if(firtLoad==NO){
        
        //写入值
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        KeyChainOpr *opr=[[KeyChainOpr alloc]init];
        [opr setKeyChainValue];
        
        NSLog(@"第一次启动");
    }
    else{
        NSLog(@"不是第一次启动");
    }
    
    
    self.navController=[[UINavigationController alloc]init];
    
    LoginViewController *loginVC=[[LoginViewController alloc]init];
    MainViewController *mainVC=[[MainViewController alloc]init];
    
    //去用户表选择最新的用户根据更新时间，表示最后登录的那个
//    _userInfo=[self getLastUser];
    
    //检测版本更新
    
//    [self checkVersion];
    
    //todo
    BOOL isLogout=true;
    if (_userInfo!=nil &&_userInfo!=(id)[NSNull null]) {
        isLogout=_userInfo.IsLogout;
    }
    //读取本地数据库，看用户是否退出系统
    if(isLogout)
    {
        loginVC.delegate=self;
        [self.navController pushViewController:loginVC animated:YES];
    }
    else
    {
        [self.navController pushViewController:mainVC animated:YES];
    }
    
    [self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.stone.SmartHomeNew2" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SmartHomeNew2" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SmartHomeNew2.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - CommonFuntion
-(NSString *)VertyTel:(NSString *)tel
{
    NSString *errorMes=@"";
    //1、是否为空
    //2、是否符合正则表达式验证输入字符的正确性
    if ([tel isEqualToString:@""]) {
        errorMes=@"输入的手机号不能为空";
    }
    else{
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PhoneReg];
        if (([pred evaluateWithObject:tel] == NO))
        {
            errorMes=@"输入的手机号不合法";
        }
       
    }
     return errorMes;
}

//验证密码是否符合正则表达式
-(NSString *)VertyPassword:(NSString *)fieldText{
   
    NSString *errorMes=@"";
    if([fieldText isEqualToString:@""])
    {
        errorMes=@"输入字符不能为空！";
    }
    
    //验证是否符合正则表达式
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", PassWordReg];
    
    if (![pred evaluateWithObject:fieldText]) {
       errorMes=@"密码由6-12位数字和字母组成";
    }
    return errorMes;
}

#pragma mark-获取设备唯一标示

#pragma mark-获取iP地址

//获取iP地址
- (NSString *)localIPAddress
{
    NSString *localIP = nil;
    struct ifaddrs *addrs;
    if (getifaddrs(&addrs)==0) {
        const struct ifaddrs *cursor = addrs;
        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                //NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                //if ([name isEqualToString:@"en0"]) // Wi-Fi adapter
                {
                    localIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    break;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return localIP;
}

-(NSData *)postDataWithRet:(NSString *)ret uid:(NSString *)uid data:(NSDictionary *)data time:(NSString *)time sign:(NSString *)sign;{
    
    NSData *postdata=nil;
    

    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:ret forKey:@"ret"];
    [dic setObject:uid forKey:@"uid"];
    [dic setObject:time forKey:@"time"];
    [dic setObject:sign forKey:@"sign"];
    [dic setObject:data forKey:@"data"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    
    
    NSString *jsonStr=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *param=[NSString stringWithFormat:@"msg=%@",jsonStr];
    NSLog(@"%@",param);
    postdata= [param dataUsingEncoding:NSUTF8StringEncoding];
    return postdata;
}

//根据返回码获取错误信息
-(NSString *)getErrorMesByRet:(NSString *)ret{
    NSString *retMes=@"";
    if ([ret isEqualToString:@"000000"]) {
        retMes=@"操作成功";
    }
    else if ([ret isEqualToString:@"100101"]){
         retMes=@"用户ID非法";
    }
    else if ([ret isEqualToString:@"100102"]){
        retMes=@"签名不正确";
    }
    else if ([ret isEqualToString:@"100205"]){
        retMes=@"请求时间不正确";
    }
    else if ([ret isEqualToString:@"100401"]){
        retMes=@"请求超时";
    }
    else if ([ret isEqualToString:@"100404"]){
        retMes=@"未知错误";
    }
    else if ([ret isEqualToString:@"100405"]){
        retMes=@"提交的参数不正确";
    }
    else if ([ret isEqualToString:@"100103"]){
        retMes=@"短信验证码错误";
    }
    else if ([ret isEqualToString:@"100104"]){
        retMes=@"登录异常";
    }
    else if ([ret isEqualToString:@"100105"]){
        retMes=@"新旧密码一致";
    }
    else if ([ret isEqualToString:@"100106"]){
        retMes=@"密码错误";
    }
    else if ([ret isEqualToString:@"100107"]){
        retMes=@"密码错误";
    }
    else if ([ret isEqualToString:@"100104"]){
        retMes=@"数据存在";
    }
    else if ([ret isEqualToString:@"100108"]){
        retMes=@"数据不存在";
    }
    return retMes;
}

//获取当前时间
-(NSString *)getCurrentTimeByDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

-(NSString *)getCurrentDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}


#pragma mark-获取最新登录的用户

-(CottomerUser *)getLastUser{

    NSManagedObjectContext *context=_managedObjectContext;
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:DE_Tl_cuttomer_user];
    request.predicate=[NSPredicate predicateWithFormat:@"max(%@)",[NSDate date]];
    NSArray *excuteResult=[context executeFetchRequest:request error:nil];
    
    if (excuteResult==nil||excuteResult.count<=0)
    {
        NSLog(@"不存查找的对象");
        
        return nil;
    }
    else return excuteResult[0];
}

-(NSString *)getAppVersion{
    NSString *key = (NSString *)kCFBundleVersionKey;
    // 1.从plist中取出版本号
    
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    return version;
}

-(NSString *)getRet{
    NSString *ret=@"";
    KeyChainOpr *opr=[[KeyChainOpr alloc]init];
    NSString *uuid=@"001011203340567";
//    [opr gen_uuid];
    NSString *version=[NSString stringWithFormat:@"V%@0",[appDelegate getAppVersion]] ;//版本号
    ret=[uuid stringByAppendingString:version];
    return ret;
}

#pragma mark-登录委托
-(void)saveUserInfo:(CottomerUser *)newuser{
    _userInfo=newuser;
    NSLog(@"%@",_userInfo.UserTel);
}

#pragma mark-检测版本更新
-(void)checkVersion{
    _command=com_updatVersion;
    [self PostServer];
}
#pragma mark-数据库操作

#pragma mark-网络通讯
-(void)PostServer{
    
    _mData =nil;//清空数据
    _mData=[[NSMutableData alloc]init];
    
    NSString *url;
    
    NSMutableDictionary *subData=[[NSMutableDictionary alloc]init];

    if (_command==com_updatVersion) {
        url=[ServerUrl stringByAppendingString:@"/updatVersion"];
    }

    NSData *data=[appDelegate postDataWithRet:[self getRet] uid:@"" data:subData time:[self getCurrentTimeByDate:[NSDate date]] sign:@""];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [self.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
    
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%@",response.description);
}

//接收数据完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    id data=[NSJSONSerialization JSONObjectWithData:_mData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"%@",data);
    
    if (data==nil||data ==(id)([NSNull null])){
        //LOG
        NSLog(@"数据为空");
        [self.window showHUDWithText:@"请求数据有误" Type:ShowPhotoNo Enabled:YES];
    }
    else{
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        
        NSString *ret=[dic objectForKey:@"ret"];
        
        if (![ret isEqualToString:@"000000"]) {
            NSString *errorMes=[appDelegate getErrorMesByRet:ret];
            NSLog(@"%@",errorMes);
            [self.window showHUDWithText:errorMes Type:ShowPhotoNo Enabled:YES];
        }
        else{
            
            if (_command==com_updatVersion) {
                //数据记录本地数据库
                NSDictionary *reciveData=[dic objectForKey:@"data"];
                NSLog(@"%@",reciveData);
                
             }
            
        }
        
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.description);
}


#pragma mark-获取房间类型
-(NSString *)getRoomImageWithRoomtype:(NSString *)roomType{
    if (_roomTypes==nil||_roomTypes==(id)[NSNull null]||_roomTypes.count<=0) {
        return @"";
    }
    for (RoomType *tempType in _roomTypes) {
        if ([roomType isEqualToString:tempType.roomtypeid]) {
            return tempType.roomimg;
        }
    }
    return @"";
}


@end
