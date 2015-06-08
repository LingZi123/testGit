//
//  AddRoomViewController.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/25.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICombox.h"
#import "CommandEnum.h"
#import "RoomType.h"

@protocol AddRoomViewControllerDelegate <NSObject>

-(void)addRoomSucess;// 添加房间成功

@end

@interface AddRoomViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    IBOutlet UILabel *_roomTypeLabel;
    IBOutlet UITextField *_roomNameTextField;
    IBOutlet UIImageView *_roomImageView;

    IBOutlet UIPickerView *_roomTypePickerView;
    IBOutlet UIButton *_roomButtonType;
    
    NSMutableArray *_roomTypeArray;//房间类型数组。包含图片名称
    NSMutableData *_mData;
    NSMutableArray *_roomTypeArryFromServer;//从服务器获取的房间类型
    CommandType _command;//命令 类型
    IBOutlet UIActivityIndicatorView *_loadingView;
    BOOL _isVerty;//是否存在该房间名称
    RoomType *_selectRoomType;//选择的房间类型
}
- (IBAction)_roomButtonClick:(id)sender;

- (IBAction)roomNameEditDidEnd:(id)sender;

@property(nonatomic,retain) id<AddRoomViewControllerDelegate> delegate;

@end
