//
//  UIComboxView.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/26.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIComboxView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UIPickerView *_pickView;
}

@property(nonatomic,retain)NSArray *Items;

- (IBAction)OKClick:(id)sender;
- (IBAction)CancelClick:(id)sender;

@end
