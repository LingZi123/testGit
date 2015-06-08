//
//  LoginViewController.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/19.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "CommonDefine.h"
#import "MainViewController.h" 
#import "UIWindow+YzdHUD.h"
#import "JsonToModel.h"
#import "KeyChainOpr.h"
#import "AppDelegate.h"
#import "Tl_cuttomer_user.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor                                                      ]];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];

    
    //设置颜色
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nag.png"] forBarMetrics:UIBarMetricsDefault];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    if (appDelegate.userInfo!=nil&&appDelegate.userInfo!=(id)[NSNull null]) {
        _tfUserTel.text=appDelegate.userInfo.UserTel;
        _tfUserPass.text=appDelegate.userInfo.UserPass;
        _getVertyCodeButton.hidden=YES;
        _tfVertyCode.hidden=YES;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_tfUserTel resignFirstResponder];
    [_tfUserPass resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark-按钮事件

- (IBAction)GetVertyCode:(id)sender {
    
    //请求服务端发送验证码
    _tfVertyCode.enabled=YES;
    _command=com_getVerificationCode;
    [self PostServer];
    //发送验证码
    //请求服务端发送验证码，并且进行一分钟的倒计时
    //开始倒计时
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

- (IBAction)ForgetPass:(id)sender {
    //跳转到忘记密码界面
    
    RegistViewController *forgetPassVC=[[RegistViewController alloc]initWithTitle:@"忘记密码"];
    [self.navigationController pushViewController:forgetPassVC animated:YES];
}

- (IBAction)Login:(id)sender {
    if ([_tfUserTel.text isEqualToString:@""]||[_tfUserPass.text isEqualToString:@""]) {
        return;
    }
    else{
        //请求服务器进行登录
        _command=com_Login;
        [self PostServer];
    }
}

- (IBAction)Regist:(id)sender {
    RegistViewController *resgitVC=[[RegistViewController alloc]initWithTitle:@"注册"];
    
    [self.navigationController pushViewController:resgitVC animated:YES];
}

- (IBAction)IsRemeberPass:(id)sender {
    
    UIButton *checkButton=sender;
    checkButton.selected=!checkButton.selected;
    if (checkButton.selected) {
        [checkButton setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        _isRemberPwd=YES;
    }
    else {
        [checkButton setBackgroundImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        _isRemberPwd=NO;// 登录成功后记录数据库保存
    }
}



-(id)initWithUserTel:(NSString *)userTel{
    self = [super init];
    if (self) {
        _tfUserTel.text=userTel;
        _tfVertyCode.hidden=YES;
        _getVertyCodeButton.hidden=YES;
    }
    return self;
}

#pragma mark-初始化

-(id)initWithUserTel:(NSString *)userTel  Userpass:(NSString *)userpass IsRemeberPass:(BOOL)isRemeberPass{
    self = [super init];
    if (self) {
        _tfUserTel.text=userTel;
        _tfVertyCode.hidden=YES;
        _getVertyCodeButton.hidden=YES;
        _tfUserPass.text=userpass;
        if (isRemeberPass) {
            _remeberPassButton.titleLabel.text=@"√";
        }
        else
        {
            _remeberPassButton.titleLabel.text=@"";
        }
        
    }
    return self;
}

#pragma mark-文本委托

- (IBAction)UserTelEditingDidEnd:(id)sender {
    NSString *errorMes=[appDelegate VertyTel:_tfUserTel.text];
    
    if (![errorMes isEqualToString:@""]) {
        
        [self.view.window showHUDWithText:errorMes Type:ShowPhotoNo Enabled:YES];
    }
}

//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    if (_seconds == 0) {
        [theTimer invalidate];
        _seconds = 60;
        [_getVertyCodeButton setTitle:@"获取验证码" forState: UIControlStateNormal];
        [_getVertyCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_getVertyCodeButton setEnabled:YES];
    }
    else{
        _seconds--;
        NSString *title = [NSString stringWithFormat:@"%d 秒",_seconds];
        [_getVertyCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_getVertyCodeButton setEnabled:NO];
        [_getVertyCodeButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)releaseTImer {
    if (_timer) {
        if ([_timer respondsToSelector:@selector(isValid)]) {
            if ([_timer isValid]) {
                [_timer invalidate];
                _seconds = 60;
            }
        }
    }
}

#pragma mark-网络请求

-(void)PostServer{
    
    _mData =nil;//清空数据
    _mData=[[NSMutableData alloc]init];
    
    NSString *url;
    
    NSMutableDictionary *subData=[[NSMutableDictionary alloc]init];
    NSString *loginIp=[appDelegate localIPAddress];
    [subData setObject:_tfUserTel.text forKey:@"usertel"];

    if (_command==com_Login) {
        url=[ServerUrl stringByAppendingString:@"/login/"];
        [subData setObject:_tfUserPass.text forKey:@"userpass"];
        [subData setObject:_tfVertyCode.text forKey:@"sendcode"];
        [subData setObject:loginIp forKey:@"loginip"];
          }
    else if (_command==com_getVerificationCode){
        url=[ServerUrl stringByAppendingString:@"/getverificationcode"];
    }
    
    NSData *data=[appDelegate postDataWithRet:[appDelegate getRet] uid:_tfUserTel.text data:subData time:[appDelegate getCurrentTimeByDate:[NSDate date]] sign:@""];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
     NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
//    [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
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
            if (_command==com_Login&& [ret isEqualToString:@"100104"]) {
                _tfVertyCode.hidden=NO;
                _getVertyCodeButton.hidden=NO;
            }
        }
        else{
            
            if (_command==com_Login) {
                //数据记录本地数据库
                NSDictionary *reciveData=[data objectForKey:@"data"];
                
               CottomerUser *user = [CottomerUser getUserByDic:reciveData];

                //赋值
                
                if (_isRemberPwd) {
                    user.IsRemeberPwd=YES;
                }
                else{
                    user.IsRemeberPwd=NO;
                }
                 [self.delegate saveUserInfo:user];
                
                //更新数据库
                
                NSInteger isupdate=[CottomerUser Update:user];
                if (isupdate==0) {
                    //如果不是首次在此手机登陆则添加
                    [CottomerUser InsertUser:user];
                }
            }
            
            //登陆成功后进入主界面
            MainViewController *mainVC=[[MainViewController alloc]init];
            //设置为主视图
            [appDelegate.navController pushViewController:mainVC animated:YES];
            [appDelegate.window addSubview:appDelegate.navController.view];
        }
            
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.description);
}

#pragma mark-数据库
//-(BOOL)existUser:(NSString *)userInfo{
//    
//    NSManagedObjectContext *context=[appDelegate managedObjectContext ];
//
//    NSFetchRequest *f=[NSFetchRequest fetchRequestWithEntityName:@"Tl_cuttomer_user"];
//
//    NSArray *excuteResult=[context executeFetchRequest:f error:nil];
//    
//    if (excuteResult==nil||excuteResult.count<=0)
//    {
//        NSLog(@"不存查找的对象");
//        
//        return NO;
//    }
//    return YES;
//
//}

@end
