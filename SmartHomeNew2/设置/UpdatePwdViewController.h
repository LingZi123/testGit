//
//  UpdatePwdViewController.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/22.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandEnum.h"

@interface UpdatePwdViewController : UIViewController
{
    
    IBOutlet UITextField *_oldPwdTextField;
    IBOutlet UITextField *_newPwdTextField;
    IBOutlet UITextField *_newOncePwdTextField;
    BOOL _oldPwdOk;
    BOOL _newPwdOk;
    BOOL _newOncePwdOk;
    
    CommandType _command;
    NSMutableData *_mData;
}

- (IBAction)OldPwdEditDidEnd:(id)sender;

- (IBAction)NewPwdEditDidEnd:(id)sender;

- (IBAction)NewPwdOnceEditDidEnd:(id)sender;



@end
