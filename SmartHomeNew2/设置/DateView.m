//
//  DateView.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/25.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "DateView.h"

@implementation DateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
   }
*/

- (IBAction)ShowDatePicker:(id)sender {
    _showDatePickerButton.selected=!_showDatePickerButton.selected;
    if (_showDatePickerButton.selected) {
        _datepicker.hidden=NO;
    }
}
- (IBAction)DatePickValueChanged:(id)sender {
    NSDate *date =_datepicker.date;
    _ContentTextField.text=[NSString stringWithFormat:@"%@",date];
}
@end
