//
//  RoomViewController.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/27.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandEnum.h"


@interface RoomViewController : UIViewController{
    
    IBOutlet UIScrollView *_deviceScrollView;
    CommandType _command;//命令
    NSMutableData *_mData;//接收服务器数据
    IBOutlet UIPageControl *_pageControl;
    NSMutableArray *_deviceArray;
    CGFloat _viewWidth;//view的宽度
    CGFloat _viewHeght;//view的高度
    UIButton *_selectButton;//当前点击的按钮
    UIAlertView *_deviceAlertView;//显示按钮
    IBOutlet UIActivityIndicatorView *_loadingView;
}

-(instancetype)initWithTitle;

@end
