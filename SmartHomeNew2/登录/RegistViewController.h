//
//  RegistViewController.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/19.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandEnum.h"

//注册页面也忘记密码页面共用
@interface RegistViewController : UIViewController<NSURLConnectionDataDelegate>
{
    
//    IBOutlet UILabel *_telErrorMes;//验证手机号的错误提示
    BOOL _VertyResult;//手机号验证结果
    NSTimer *_timer;//倒计时
    int _seconds;//倒计时秒数
    IBOutlet UIButton *_GetVertyCodeButton;//获取验证码按钮
    NSMutableData *_mData;//接收服务器返回的数据
    NSString *_pageTitle;//页面title 是注册页面还是忘记密码页面
    CommandType _command;// 命令
    IBOutlet UIActivityIndicatorView *_loadingView;
}


@property (strong, nonatomic) IBOutlet UITextField *tfUserTel;//手机号码
@property (strong, nonatomic) IBOutlet UITextField *tfVertyCode;//验证码
- (IBAction)GetVertyCode:(id)sender;//获取验证码
- (IBAction)Next:(id)sender;//下一步

- (IBAction)VertyTelDidEnd:(id)sender;//电话号码编辑结束后验证手机号

-(id)initWithTitle:(NSString *)title;

- (IBAction)GoBack:(id)sender;
@end
