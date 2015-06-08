//
//  EditRoomViewController.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/6/3.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandEnum.h"

@interface EditRoomViewController : UIViewController
{
    IBOutlet UIActivityIndicatorView *_loadingView;
    NSString *_roomname;//房间名称
    NSString *_roomid;//房间号
    IBOutlet UITextField *_roomNameTextField;
    CommandType _command;//命令
    NSMutableData *_mData;//网络数据
}
-(id)initWithTitle:(NSString *)roomName roomId:(NSString *)roomId;
@end
