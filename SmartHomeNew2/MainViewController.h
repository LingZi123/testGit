//
//  MainViewController.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/20.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandEnum.h"
#import "AddRoomViewController.h"
#import "CustomerRoom.h"

@interface MainViewController : UIViewController<NSURLConnectionDataDelegate,AddRoomViewControllerDelegate,UIAlertViewDelegate,UIScrollViewDelegate>
{
    
    IBOutlet UIScrollView *_roomScrollView;//房间面板
    IBOutlet UIScrollView *_safeScrollView;//安防面板
    IBOutlet UIScrollView *_scenceScrollView;// 情景模式面板
    
    UIButton *_roomButton;
    UIButton *_anfangButton;
    UIButton *_changjingButton;
    
    NSMutableData *_mData;//服务器数据
    CommandType _command;//
    
    NSMutableArray *_roomArray;//房间
    NSInteger _roomPageCount;//房间分页数
    NSInteger _anfangPageCount;
    NSInteger _changjingPageCount;
    
    IBOutlet UIActivityIndicatorView *_loadingView;
    
    IBOutlet UIPageControl *_roomPageControl;
    
    UIAlertView *_selectRoomAlertView;//
    
    CustomerRoom *_selectRoom ;//当前选择的数据
    
    UIButton *_selectButton;//当前选中的buton
    
    CGFloat _viewWidth;//view的宽度
    CGFloat _viewHeght;//view的高度
    
}

@end
