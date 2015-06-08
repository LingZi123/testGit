//
//  UICityPicker.m
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

#import "UIComboxView.h"
#import "UIComboxModel.h"
#import "BrandAndModel.h"
#import "ModelTypeModel.h"

#define kDuration 0.3

@implementation UIComboxView


- (id)initWithInfo:(id)delegate items:(NSMutableDictionary *)data
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"UIComboxView" owner:self options:nil] objectAtIndex:0];
    if (self)
    {
        self.delegate = delegate;
        _dataDic=data;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        _brandMArray=[[NSMutableArray alloc]init];
        for (id brand in [data objectForKey:@"listbrand"])
        {
            [_brandMArray addObject:brand];
        }
        
        //默认选第一个
        _modelMArray=[[NSMutableArray alloc]init];
        NSDictionary *_tempBrand=[_brandMArray objectAtIndex:0];
        _selectModel=[[BrandAndModel alloc]init];
        _selectModel.brand=[[BrandTypeModel alloc]initWithContent:_tempBrand];
        for (id subModel in [_tempBrand objectForKey:@"listmodel"])
        {
            [_modelMArray addObject:subModel];
        }
        if ([_modelMArray count]>0)
        {
            _selectModel.model=[[ModelTypeModel alloc]initWithContent:[_modelMArray objectAtIndex:0]];
        }
        
    }
    return self;
}

- (void)showInView:(UIView *) view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [view addSubview:self];
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([_modelMArray count]>0)
    {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
        switch (component) {
            case 0:
            {
                if ([_brandMArray count]>0)
                {
                     return [_brandMArray count];
                }
               else
               {
                   return 0;
               }
            }
                break;
            case 1:
            {
                if ([_modelMArray count]>0) {
                     return [_modelMArray count];
                }
               else
               {
                   return 0;
               }
            }
                break;
                
            default:
                return 0;
                break;
        }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        switch (component) {
            case 0:
                if ([_brandMArray count]>0)
                {
                    return [[_brandMArray objectAtIndex:row] objectForKey:@"name"];

                }
                else
                {
                    return @"";
                }
                break;
            case 1:
            {
                if ([_modelMArray count]>0)
                {
                    ModelTypeModel *_tempmodel=[[ModelTypeModel alloc]initWithContent:[_modelMArray objectAtIndex:row]];
                    return _tempmodel.name;
                }
                else
                {
                    return @"";
                }
              
            }
                break;
            default:
                return nil;
                break;
        }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
        switch (component)
    {
            case 0:
            {
    
                _modelMArray=[[_brandMArray objectAtIndex:row] objectForKey:@"listmodel"];
                
                self.selectModel.brand.ids = [[_brandMArray objectAtIndex:row] objectForKey:@"id"];
                self.selectModel.brand.name = [[_brandMArray objectAtIndex:row] objectForKey:@"name"];

                
                if ([_modelMArray count]>0)
                {
                    [self numberOfComponentsInPickerView:pickerView];
                    
                    [self.locatePicker selectRow:0 inComponent:1 animated:NO];
                    [self.locatePicker reloadComponent:1];
                    self.selectModel.model =[[ModelTypeModel alloc]initWithContent:[_modelMArray objectAtIndex:0]];

                }
               
            }
                break;
            case 1:
            {
                if ([_modelMArray count]>0)
                {
                    ModelTypeModel *tepm =[[ModelTypeModel alloc]initWithContent:[_modelMArray objectAtIndex:row]];
                    _selectModel.model=tepm;
                }
    
            }
                break;
            default:
                break;
        }
}


#pragma mark - Button lifecycle

- (IBAction)cancel:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"UIComboxView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}

- (IBAction)locate:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"UIComboxView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
    
}

@end
