//
//  RegistViewController.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/19.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "RegistViewController.h"
#import "CommonDefine.h"
#import <CoreData/CoreData.h>
#import "InputPassViewController.h"
#import "UIWindow+YzdHUD.h"
#import "CommandEnum.h"

@interface RegistViewController ()

@end

@implementation RegistViewController

-(id)initWithTitle:(NSString *)title{

    self = [super init];
    if (self) {
        _pageTitle=title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationController];
    _VertyResult=false;
    _seconds=60;
    _loadingView.hidden=YES;
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_tfUserTel resignFirstResponder];
    [_tfVertyCode resignFirstResponder];
}
#pragma mark-初始化

//初始化导航条
-(void)initNavigationController{
    
    [self.navigationItem setTitle:_pageTitle];
    
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(GoBack:)];
    
    self.navigationItem.leftBarButtonItem=leftBar;
    
//    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(Next:)];
//    
//    self.navigationItem.rightBarButtonItem=rightBar;
    
}


#pragma mark-定时器
//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    if (_seconds == 0) {
        [theTimer invalidate];
        _seconds = 60;
        [_GetVertyCodeButton setTitle:@"获取验证码" forState: UIControlStateNormal];
        [_GetVertyCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_GetVertyCodeButton setEnabled:YES];
    }
    else{
        _seconds--;
        NSString *title = [NSString stringWithFormat:@"%d 秒",_seconds];
        [_GetVertyCodeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_GetVertyCodeButton setEnabled:NO];
        [_GetVertyCodeButton setTitle:title forState:UIControlStateNormal];
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

#pragma mark-数据操作
//获取验证码
- (IBAction)GetVertyCode:(id)sender {
    if(!_VertyResult)
        return;
    else{
        //发送验证码
        //请求服务端发送验证码，并且进行一分钟的倒计时
        
        _command=com_getVerificationCode;
        [self PostServer];
        
        //开始倒计时
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        
        }
}

-(void)VertyTel
{
    _VertyResult=false;
    //1、是否为空
    //2、是否符合正则表达式验证输入字符的正确性
    //3、请求服务器验证手机号是否被注册过
    NSString *errorMes =[appDelegate  VertyTel:_tfUserTel.text];
//    _telErrorMes.text=errorMes;
    
    //符合正则表达式
    if([errorMes isEqualToString:@""])
    {
        //请求服务器验证手机号是否被注册过
        
        _command=com_CheckPhone;
        [self PostServer];

    }
}
- (IBAction)VertyTelDidEnd:(id)sender {
    
    [self VertyTel];
    
    }

#pragma mark-服务器通讯

//向服务器请求数据
-(void)PostServer{
  
    _mData=nil;
    _mData=[[NSMutableData alloc]init];
    
    NSString *url=nil;
    if (_command==com_CheckPhone) {
        url=[ServerUrl stringByAppendingString:@"/checkphone"];
    }
    else if (_command==com_getVerificationCode){
        url=[ServerUrl stringByAppendingString:@"/getverificationcode"];
    }
    
    NSMutableDictionary * data=[[NSMutableDictionary alloc]init];
    [data setObject:_tfUserTel.text forKey:@"usertel"];
    
    NSData *jsonData=[appDelegate postDataWithRet:[appDelegate getRet] uid:_tfUserTel.text data:data time:[appDelegate getCurrentTimeByDate:[NSDate date ]] sign:@""];
    NSString *jsonStr=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
   
    NSString *testUrl=[url stringByAppendingString:jsonStr];
    NSLog(@"%@",testUrl);
    
    //创建请求
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:50];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    
    //    链接服务器
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    //启动加载图标
//    /[self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
    [_loadingView startAnimating];
    _loadingView.hidden=NO;
}

//网络请求过程中，出现任何错误（断网，链接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    [self.view.window showHUDWithText:@"网络有误" Type:ShowPhotoNo Enabled:YES];
}

//接收到服务器回应的时候调用此方法
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%@",response.description);
    NSLog(@"%@",response);
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
}

//数据传输完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{

    [_loadingView stopAnimating];
    _loadingView.hidden=YES;
    
    NSError *error;
    id data =[NSJSONSerialization JSONObjectWithData:_mData options:NSJSONReadingAllowFragments error:&error];
    
    
    NSLog(@"%@",data);
    //接受到响应进入下一步
    if (data==nil||data==(id)([NSNull null])) {
        NSLog(@"");
    }
    else{
//        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];

//        NSLog(@"%@",dic);
        
        NSString *ret=[data objectForKey:@"ret"];
        
        if (![ret isEqualToString:@"000000"]){
           if (_command ==com_CheckPhone&&
               [_pageTitle isEqualToString:@"忘记密码"]&&
               [ret isEqualToString:@"100107"]) {
                //手机号是存在的可以进行密码修改
                _VertyResult=true;
                
            }
           else{
            NSString *errorMes=[appDelegate getErrorMesByRet:ret];
            [self.view.window showHUDWithText:errorMes Type:ShowPhotoNo Enabled:YES];
            
            if(_command==com_CheckPhone) {
                NSLog(@"%@",errorMes);
                _VertyResult=false;
            }
           }
        }
        else{
            
//            self.view.window
            
            if(_command==com_CheckPhone) {
                NSLog(@"");
                _VertyResult=true;
            }
        }
    }
}

#pragma mark-导航条

- (IBAction)GoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//下一步
- (IBAction)Next:(id)sender {
    //验证码和手机号验证通过才有效
    if (_VertyResult&&![_tfVertyCode.text isEqualToString:@""]) {
        //跳转到密码确认这一页
        [self releaseTImer];
        _timer=nil;
        InputPassViewController *inputPassVC=[[InputPassViewController alloc]initWithTel:_tfUserTel.text VertyCode:_tfVertyCode.text Flag:_pageTitle];
        [self.navigationController pushViewController:inputPassVC animated:YES];        
    }
}

@end
