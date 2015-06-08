//
//  InputPassViewController.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/19.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandEnum.h"

@interface InputPassViewController : UIViewController<NSURLConnectionDataDelegate>
{
    
    IBOutlet UITextField *_firstPasswordTextField;//第一次输入密码
    IBOutlet UITextField *_secondPasswordTextField;//第二次输入密码
    NSString *_userTel;//用户电话
    NSString *_vertycode;//验证码
    NSMutableData *_mData;//接收的数据
    
    NSMutableDictionary *_postData;//提交服务器的数据
    CommandType _command;//操作命令
    IBOutlet UIButton *_complateButton;
}

@property (strong, nonatomic) IBOutlet UITextField *tfFirstPass;//第一次输入的密码
@property (strong, nonatomic) IBOutlet UITextField *tfOncePass;//第二次输入的密码
- (IBAction)Complate:(id)sender;//完成注册
- (IBAction)VertyFirst:(id)sender;//验证第一次输入密码
- (IBAction)VertySecond:(id)sender;//验证第二次输入密码
-(id)initWithTel:(NSString *)userTel VertyCode:(NSString *)VertyCode Flag:(NSString *)flag;//初始化

@end
