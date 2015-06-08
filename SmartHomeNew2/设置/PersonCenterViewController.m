//
//  PersonCenterViewController.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/22.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import "UpdatePwdViewController.h"
#import "CommonDefine.h"
#import "IdeaViewController.h"
#import "HelpViewController.h"
#import "UIWindow+YzdHUD.h"

@interface PersonCenterViewController ()

@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController setNavigationBarHidden:YES];
    
    //初始化tableview的数据
    _dataArray=[[NSArray alloc]initWithObjects:DE_USER_INFO,DE_UPDATE_PWD,DE_IDEA,DE_Kefu_Center,DE_VERSION, nil];
    _dataTV.delegate=self;
    _dataTV.dataSource=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)GoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Logout:(id)sender {
    //写入数据库
    appDelegate.userInfo.IsLogout=YES;
    [CottomerUser Update:appDelegate.userInfo];
    
//    并返回登录界面
    NSString *rootViewControlType=[NSString stringWithUTF8String:object_getClassName(appDelegate.window.rootViewController)];
    
    if ([rootViewControlType isEqualToString:@"LoginViewController"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        
        //跳转到登录界面
        LoginViewController *loginVC=[[LoginViewController alloc]initWithUserTel:@"13340375353"];
        
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
}


#pragma mark _tableview

//设置每组的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_dataArray!=nil)
        return _dataArray.count;
    else
        return 0;
}

//设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text=_dataArray[indexPath.row];
    if ([cell.textLabel.text isEqualToString:DE_USER_INFO]) {
        cell.imageView.image=[UIImage imageNamed:@"头像2.png"];
    }
    else if([cell.textLabel.text isEqualToString:DE_UPDATE_PWD]){
        cell.imageView.image=[UIImage imageNamed:@"mima.png"];
        
    }
    else if([cell.textLabel.text isEqualToString:DE_IDEA]){
        cell.imageView.image=[UIImage imageNamed:@"意见反馈.png"];
    }
    else if([cell.textLabel.text isEqualToString:DE_Kefu_Center]){
        cell.imageView.image=[UIImage imageNamed:@"使用指南.png"];
    }
    else if([cell.textLabel.text isEqualToString:DE_VERSION]){
        cell.imageView.image=[UIImage imageNamed:@"gengxin.png"];
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
    return cell;
}

//选中行时弹出相应的窗口
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectStr=_dataArray[indexPath.row];
    
    UIViewController *VC=nil;
    
    if ([selectStr isEqual:DE_USER_INFO]) {
        VC=[[UserInfoViewController alloc]init];
    }
    else if ([selectStr isEqualToString:DE_UPDATE_PWD]){
        VC=[[UpdatePwdViewController alloc]init];
    }
    else if([selectStr isEqualToString:DE_IDEA]){
        VC=[[IdeaViewController alloc]init];
    }
    else if([selectStr isEqualToString:DE_Kefu_Center]){
        VC=[[HelpViewController alloc]init];
    }
    else if ([selectStr isEqualToString:DE_VERSION]){
        _command=com_updatVersion;
        [self PostServer];
    }
    if (VC!=nil) {
        [self.navigationController pushViewController:VC animated:YES];
    }
    
}

#pragma mark-导航栏显示

#pragma mark-网络请求

-(void)PostServer{
    
    _mData =nil;//清空数据
    _mData=[[NSMutableData alloc]init];
    
    NSString *url;
    
    NSMutableDictionary *subData=[[NSMutableDictionary alloc]init];
    
    if (_command==com_updatVersion) {
        url=[ServerUrl stringByAppendingString:@"/updatVersion"];
    }
    
    NSData *data=[appDelegate postDataWithRet:[appDelegate getRet] uid:appDelegate.userInfo.UserTel data:subData time:[appDelegate getCurrentTimeByDate:[NSDate date]] sign:@""];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [self.view.window showHUDWithText:@"正在更新" Type:ShowLoading Enabled:YES];
    
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
        [self.view.window showHUDWithText:@"请求数据有误" Type:ShowPhotoNo Enabled:YES];
    }
    else{
        
        //        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        
        NSString *ret=[data objectForKey:@"ret"];
        
        if (![ret isEqualToString:@"000000"]) {
            NSString *errorMes=[appDelegate getErrorMesByRet:ret];
            NSLog(@"%@",errorMes);
            [self.view.window showHUDWithText:errorMes Type:ShowPhotoNo Enabled:YES];
        }
        else{
            
            if (_command==com_updatVersion) {
               //获取到数据
               //要更新更新房间类型，更新设备类型，更新用户信息
            }
        }
        
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.description);
}



@end
