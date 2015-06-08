//
//  DateView.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/25.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateView : UIView
{
    
    IBOutlet UIButton *_showDatePickerButton;
    IBOutlet UIDatePicker *_datepicker;
}
- (IBAction)ShowDatePicker:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *ContentTextField;

- (IBAction)DatePickValueChanged:(id)sender;

@end
