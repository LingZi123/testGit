//
//  DLTJViewController.h
//  SmartHome
//
//  Created by luojiao on 14-9-16.
//  Copyright (c) 2014年 lex. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "BrandAndModel.h"
#import "UIComboxModel.h"

@interface UIComboxView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSMutableArray *_brandMArray;
    NSMutableDictionary *_dataDic;
    NSMutableArray *_modelMArray;
}

@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) BrandAndModel *selectModel;

- (id)initWithInfo:(id)delegate items:(NSMutableDictionary *)data;

- (void)showInView:(UIView *)view;

@end
