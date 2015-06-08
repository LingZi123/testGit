//
//  LoginViewController.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/19.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandEnum.h"
#import "CottomerUser.h"

@protocol LoginViewControllerDelegate <NSObject>

-(void)saveUserInfo:(CottomerUser *)newuser;
-(void)updateUserInfo:(CottomerUser *)updateuser;

@end

@interface LoginViewController : UIViewController<NSURLConnectionDataDelegate>
{
    
    IBOutlet UIButton *_getVertyCodeButton;
    BOOL _isVertyTel;//电话
    
    IBOutlet UIButton *_remeberPassButton;
    NSTimer *_timer;//倒计时
    int _seconds;//倒计时秒数
    IBOutlet UIButton *_loginButton;
    BOOL _isRemberPwd;//是否记住密码
    
    NSMutableData *_mData;//网络数据
    CommandType _command;//命令
}

//用户手机号
@property (strong, nonatomic) IBOutlet UITextField *tfUserTel;

//用户密码
@property (strong, nonatomic) IBOutlet UITextField *tfUserPass;

//验证码
@property (strong, nonatomic) IBOutlet UITextField *tfVertyCode;

//获取验证码
- (IBAction)GetVertyCode:(id)sender;

//忘记密码
- (IBAction)ForgetPass:(id)sender;

//登陆
- (IBAction)Login:(id)sender;

//注册
- (IBAction)Regist:(id)sender;

//是否记住密码
- (IBAction)IsRemeberPass:(id)sender;

-(id)initWithUserTel:(NSString *)userTel;

- (IBAction)UserTelEditingDidEnd:(id)sender;

-(id)initWithUserTel:(NSString *)userTel  Userpass:(NSString *)userpass IsRemeberPass:(BOOL)isRemeberPass;

@property(nonatomic,retain) id<LoginViewControllerDelegate>delegate;

@end
