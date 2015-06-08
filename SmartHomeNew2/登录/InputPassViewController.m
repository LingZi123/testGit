//
//  InputPassViewController.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/19.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "InputPassViewController.h"
#import "CommonDefine.h"
#import "LoginViewController.h"
#import "CottomerUser.h"
#import "Tl_cuttomer_user.h"
#import "UIWindow+YzdHUD.h"

@interface InputPassViewController ()

@end

@implementation InputPassViewController

-(id)initWithTel:(NSString *)userTel VertyCode:(NSString *)VertyCode Flag:(NSString *)flag
{
    self = [super init];
    if (self) {
        _userTel=userTel;
        _vertycode=VertyCode;
        if ([flag isEqualToString:@"忘记密码"]) {
            _command=com_Forgetpass;
        }
        else if ([flag isEqualToString:@"注册"]){
             _command=com_Register;
        }
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationController];
    
    _complateButton.enabled=NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_tfFirstPass resignFirstResponder];
    [_tfOncePass resignFirstResponder];
}

#pragma mark-初始化

//初始化导航条
-(void)initNavigationController{
    
    [self.navigationItem setTitle:@"密码"];
    
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithTitle:@"返回登录" style:UIBarButtonItemStylePlain target:self action:@selector(GoBack:)];
    
    self.navigationItem.leftBarButtonItem=leftBar;
    
    //    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(Next:)];
    //
    //    self.navigationItem.rightBarButtonItem=rightBar;
}


#pragma mark-控件操作

//验证密码是否符合正则表达式
-(BOOL)VertyPassword:(id)sender{
   
    UITextField *fieldText=sender;
    NSString *errorMes =[appDelegate VertyPassword:fieldText.text];
    if ([errorMes isEqualToString:@""]) {
        return true;
    }
    else
        return false;
}


- (IBAction)VertyFirst:(id)sender {
    if (![self VertyPassword:sender]) {
        
        [self.view.window showHUDWithText:@"密码格式不对" Type:ShowPhotoNo Enabled:YES];
        
        _secondPasswordTextField.enabled=false;
    }
    else
        _secondPasswordTextField.enabled=true;
}


- (IBAction)VertySecond:(id)sender {
    BOOL result=[self VertyPassword:sender];
    
    if (result==NO||![_firstPasswordTextField.text isEqualToString: _secondPasswordTextField.text]) {
        [self.view.window showHUDWithText:@"密码格式不对或两次密码不等" Type:ShowPhotoNo Enabled:YES];
    }
    else {
        _complateButton.enabled=YES;
        [self.view.window showHUDWithText:@"ok" Type:ShowPhotoYes Enabled:YES];
    }
}

#pragma mark-服务器通讯

//向服务器请求数据
-(void)PostServer{
    _mData =nil;//清空数据
    _mData=[[NSMutableData alloc]init];
    
    NSString *url;
    
    _postData=[[NSMutableDictionary alloc]init];
    [_postData setObject:_userTel forKey:@"usertel"];
    [_postData setObject:_tfOncePass.text forKey:@"userpass"];
    [_postData setObject:_vertycode forKey:@"sendcode"];
   
    if (_command==com_Forgetpass) {
       
        url=[ServerUrl stringByAppendingString:@"/forgetpass"];
        }
    else if(_command==com_Register){
        //        注册
         url=[ServerUrl stringByAppendingString:@"/register"];
      
        // [_postData setObject:[appDelegate localIPAddress] forKey:@"loginip"];

        // [_postData setObject:@"" forKey:@"imeinum"];
    }
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:50];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSData *postdata=[appDelegate postDataWithRet:[appDelegate getRet] uid:_userTel data:_postData time:[appDelegate getCurrentTimeByDate:[NSDate date]] sign:@""];
    
    
    [request setHTTPBody:postdata];
    
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
    
}

//不断接收服务器返回的数据

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
}

//收到服务器的反馈
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%@",response.description);
}

//接收数据完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    id data=[NSJSONSerialization JSONObjectWithData:_mData options:NSJSONReadingAllowFragments error:nil];
    
    //根据判断flag解析数据
    
    if (data==nil||data ==(id)([NSNull null])) {
        //错误的
        [self.view.window showHUDWithText:@"获取数据有误" Type:ShowPhotoNo Enabled:YES];
    }
    else{
        
//        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *reviceData=[data objectForKey:@"data"];
        NSString *ret=[data objectForKey:@"ret"];
        
        if (![ret isEqualToString:@"000000"]) {
            
            NSString *errorMes=[appDelegate getErrorMesByRet:ret];
            NSLog(@"%@",errorMes);
            
            [self.view.window showHUDWithText:errorMes Type:ShowPhotoNo Enabled:YES];
        }
        else{
            
            if (_command==com_Forgetpass) {
                //忘记密码
                //修改本地数据库
                if ([self UpdatePwdWithTel:_userTel pwd:_tfOncePass.text]==NO) {
                    NSLog(@"保存到本地数据库失败");
                }
                [self.view.window showHUDWithText:@"修改密码成功" Type:ShowPhotoYes Enabled:YES
                 ];
            }
            else if (_command==com_Register){
                [self.view.window showHUDWithText:@"注册成功" Type:ShowPhotoYes Enabled:YES
                 ];
                appDelegate.userInfo.UserTel=_userTel;
                appDelegate.userInfo.UserPass=_tfFirstPass.text;
            }
            //返回进入登陆界面
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }

}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error.description);
}

#pragma mark- 导航条

- (void)GoBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)Complate:(id)sender {
//    if (_firstPasswordTextField.text==_secondPasswordTextField.text&&
//        ![_firstPasswordTextField.text isEqualToString:@""]) {
        //请求服务器注册
        [self PostServer];
//    }
}


#pragma mark- 数据库操作

-(void)delete:(id)sender
{
    Tl_cuttomer_user *user=[[Tl_cuttomer_user alloc]init];
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    [context deleteObject:user];
    
}

-(BOOL)UpdatePwdWithTel:(NSString *)userTel  pwd:(NSString *)pwd {
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
   
    //先查找
    NSFetchRequest *f=[NSFetchRequest fetchRequestWithEntityName:DE_Tl_cuttomer_user];
    
    NSArray *excuteResult=[context executeFetchRequest:f error:nil];
    if (excuteResult==nil||excuteResult.count<=0)
    {
        NSLog(@"不存查找的对象");
        
        return NO;
    }
    //再修改
    for (Tl_cuttomer_user *tempUser in excuteResult) {
        if (tempUser.usertel!=userTel) {
            continue;
        }
        else {
            [tempUser setUserpass:pwd];
        }
    }
    //保存
    NSError *error=nil;
    if (![context save:&error]) {
        NSLog(@"eoor %@",error);
        return YES;
    }
    else{
        NSLog(@"修改成功");
        return NO;
    }
}


@end
