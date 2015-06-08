//
//  UserInfoViewController.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/22.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandEnum.h"

@interface UserInfoViewController : UIViewController
{
    
    IBOutlet UILabel *_userTelLabel;
    IBOutlet UITextField *_trueNameTextField;
    IBOutlet UIButton *_girlButton;
    IBOutlet UIButton *_boyButton;
    NSString * _userSex;
    IBOutlet UILabel *_birthdayLabel;
    
    IBOutlet UITextField *_birthdayTextField;
    IBOutlet UIDatePicker *_datePicker;
    NSMutableData *_mData;// 接收网络数据
    CommandType _command;//命令
    
}
- (IBAction)SelectSex:(id)sender;
- (IBAction)ShowDatePicker:(id)sender;

- (IBAction)SelectDate:(id)sender;
@end
