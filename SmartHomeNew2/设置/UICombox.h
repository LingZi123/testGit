//
//  UCDatePicker.h
//
//  Created by Henry Yu on 10-11-06.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UICombox:UITextField<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
@private
	UIActionSheet *action;
	UIPickerView *picker;
}

@property(nonatomic, copy) NSArray *items;
- (void)initComponents;

@end
