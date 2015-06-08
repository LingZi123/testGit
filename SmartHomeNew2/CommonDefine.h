//
//  CommonDefine.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/19.
//  Copyright (c) 2015年 stone. All rights reserved.
//
#import "AppDelegate.h"

#ifndef SmartHomeNew2_CommonDefine_h
#define SmartHomeNew2_CommonDefine_h


#endif

//电话号码验证
#define PhoneReg @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$"
//服务器地址
#define ServerUrl @"http://192.168.0.10"

#define appDelegate ((AppDelegate*) [[UIApplication sharedApplication]delegate])

//密码验证
#define PassWordReg @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$"

//颜色值

#define GetColorFromHex(hexColor) \
[UIColor colorWithRed:((hexColor >> 16) & 0xFF) / 255.0 \
green:((hexColor >>  8) & 0xFF) / 255.0 \
blue:((hexColor >>  0) & 0xFF) / 255.0 \
alpha:((hexColor >> 24) & 0xFF) / 255.0]

//验证码字颜色
#define VertyCodeButtonTitleColor [UIColor colorWithRed:0xC1/255.0 green:0xC0/255.0 blue:0xBF/255.0 alpha:1]

//验证码button背景色
#define VertyCodeButtonBlackgroundColor [UIColor colorWithRed:0x28/255.0 green:0x69/255.0 blue:0xAA/255.0 alpha:1]

//登录按钮颜色
#define LoginButtonBlackgroundColor [UIColor colorWithRed:0x21/255.0 green:0x3C/255.0 blue:0x62/255.0 alpha:1]

//textField边框颜色
//#define TextfieldBoldColor

#pragma mark-数据库表明

#define DE_Tl_cuttomer_user @"Tl_cuttomer_user"
#define DE_Tl_room_type @"Tl_room_type"
#define DE_App_help @"App_help"

#pragma mark-个人中心

#define DE_USER_INFO @"我的资料"
//#define DE_UPDATE_TEL @"安全设置"
#define DE_UPDATE_PWD @"安全设置"
#define DE_VERSION @"检测更新"
#define DE_IDEA @"意见反馈"
#define DE_Kefu_Center @"客服中心"

#pragma mark-设备相关

#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kSystemVersion [[UIDevice currentDevice]systemVersion]

//addButton
#define kIphoneaddButtonX       20
#define kIphoneaddButtonXGap    100
#define kIphoneaddButtonY       10
#define kIphoneaddButtonYGap    100
#define kIphoneaddButtonWidth   60
#define kIphoneaddButtonHeight  60
//addLabel
#define kIphoneaddLabelX      20
#define kIphoneaddLabelXGap   100
#define kIphoneaddLabelY      110
#define kIphoneaddLabelYGap   100
#define kIphoneaddLabelWidth  60
#define kIphoneaddLabelHeight 20
