//
//  AddDeviceViewController.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/27.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
@interface AddDeviceViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,ZBarReaderDelegate>
{
    
    IBOutlet UITextField *_deviceNameTextField;
    IBOutlet UIImageView *_DeviceTypeImage;
    IBOutlet UIPickerView *_devicePicker;
    IBOutlet UIView *_contentView;
    IBOutlet UIButton *_deviceTypeButton;
    IBOutlet UIButton *_uidButton;
    IBOutlet UITextField *_pwdTextField;
    IBOutlet UIImageView *_scanImageView;
    NSString *_uidCode;//uid码
    NSArray *_deviceTypeArray;//
    IBOutlet UIView *_wifiView;
   }
- (IBAction)selectDeviceTypeClick:(id)sender;


- (IBAction)SaoYiSao:(id)sender;

@end
