//
//  UIComboxView.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/26.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "UIComboxView.h"

@implementation UIComboxView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_Items count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_Items objectAtIndex:row];
}
- (IBAction)OKClick:(id)sender {
    
}

- (IBAction)CancelClick:(id)sender {
    
}
@end
