//
//  UCDatePicker.m
//
//  Created by Henry Yu on 10-11-06.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//

#import "UICombox.h"

@implementation UICombox

@synthesize items;

- (BOOL)canBecomeFirstResponder {
	return YES;	
}

- (BOOL)becomeFirstResponder {
	if(action == nil)
		[self initComponents]; 	
	if(action != nil){
		UIWindow* appWindow = [self window];
		[action showInView: appWindow];
		[action setBounds:CGRectMake(0, 0, 320, 500)];
        //如果当前输入框内有内容
        if (self.text.length > 0) {
            //将横条定位于当前选项
            [picker selectRow:[items indexOfObject:self.text] inComponent:0 animated:NO];
        }
	}	
    return YES;
}

- (void)dealloc {
    items = nil;
    picker = nil;
	if(action != nil){
	    [action dismissWithClickedButtonIndex:1  animated:YES];	
	    [action release];
	    action = nil;
	}
	[super dealloc];
}

- (void)didMoveToSuperview 
{	
	action = nil;

	// lets load our indecicator image and get its size.
	CGRect bounds = self.bounds;
	UIImage* image = [UIImage imageNamed:@"downArrow.png"];
	CGSize imageSize = image.size;
	
	// create our indicator imageview and add it as a subview of our textview.
	CGRect imageViewRect = CGRectMake((bounds.origin.x + bounds.size.width) - imageSize.width, 
									  (bounds.size.height/2) - (imageSize.height/2), 
									  imageSize.width, imageSize.height);

	UIImageView *indicator = [[UIImageView alloc] initWithFrame:imageViewRect];
	indicator.image = image;
	[self addSubview:indicator];
	[indicator release];   
	
}

-(void) didMoveToWindow {
	UIWindow* appWindow = [self window];  
	if (appWindow != nil) {        
        [self initComponents];        	
    }
}

- (void)doCancelClick:(id)sender{
	[action dismissWithClickedButtonIndex:0  animated:YES];		
}

- (void)doDoneClick:(id)sender{
	[action dismissWithClickedButtonIndex:1  animated:YES];
	//设置输入框内容
    [self setText:[items objectAtIndex:[picker selectedRowInComponent:0]]];	
}

- (void)initComponents{	
	if(action != nil) return;
    //Create UIDatePicker with UIToolbar.
	action = [[UIActionSheet alloc] initWithTitle:@""
										 delegate:nil
								cancelButtonTitle:nil
						   destructiveButtonTitle:nil
								otherButtonTitles:nil];
	//创建PickView
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    picker.dataSource = self;
    
    //顶部工具条
	UIToolbar *datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	datePickerToolbar.barStyle = UIBarStyleBlackOpaque;
	[datePickerToolbar sizeToFit];
	
    //定义两个按钮
	NSMutableArray *barItems = [[NSMutableArray alloc] init];	
	UIBarButtonItem *btnFlexibleSpace = [[UIBarButtonItem alloc] 
										 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
										 target:self action:nil];
	[barItems addObject:btnFlexibleSpace];
	[btnFlexibleSpace release];
	
	UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] 
								  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
								  target:self
								  action:@selector(doCancelClick:)];
	[barItems addObject:btnCancel];
	[btnCancel release];
	
	UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] 
								initWithBarButtonSystemItem:UIBarButtonSystemItemDone
								target:self
								action:@selector(doDoneClick:)];
	
	[barItems addObject:btnDone];
	[btnDone release];
	[datePickerToolbar setItems:barItems animated:YES];
	[barItems release];
	
	[action addSubview: datePickerToolbar];
	[action addSubview: picker];
	
	[datePickerToolbar release];
	
}

#pragma mark PickViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [items count];
}

#pragma mark PickViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [items objectAtIndex:row];
}


@end
