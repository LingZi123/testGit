//
//  CommandEnum.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/31.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    com_Login,//登录
    com_Register,//注册
    com_Forgetpass,//忘记密码
    com_CheckPhone,//检查手机号是否被注册
    com_getVerificationCode,//获取验证码
    com_updatVersion,//更新版本
    com_getRoomType,//获取所有房间类型
    com_saveRoom,//添加房价
    com_checkRoomNameIsSame,//检查房间名是否同名
    com_findRoomByUser,//通过用户查找所有房间
    com_delRoom,//删除房间
    com_updateRoomInfo,//修改房间
    com_updateuserinfo,//修改个人信息
    com_updatepass,//修改密码
    com_saveFeedback,//添加意见反馈
    com_findHelp,//帮助
    
} CommandType;

@interface CommandEnum : NSObject

@end
