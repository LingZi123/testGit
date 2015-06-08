//
//  AddDeviceViewController.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/27.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "AddDeviceViewController.h"

@interface AddDeviceViewController ()<UIAlertViewDelegate>

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationController];
    
    _deviceTypeArray =[[NSArray alloc]initWithObjects:@"电风扇",@"电视机", nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark-初始化界面

//初始化导航条
-(void)initNavigationController{
    
    [self.navigationItem setTitle:@"添加设备"];
    
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(GoBack:)];
    
    self.navigationItem.leftBarButtonItem=leftBar;
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(Save:)];
    
    self.navigationItem.rightBarButtonItem=rightBar;
}


#pragma mark-导航条

-(void)GoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)Save:(id)sender{
    //验证，请求服务端保存
    //成功返回房间界面
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark-动作
- (IBAction)selectDeviceTypeClick:(id)sender {
    _deviceTypeButton.selected=!_deviceTypeButton.selected;
    if (_deviceTypeButton.selected) {
        _devicePicker.hidden=NO;
        _contentView.hidden=YES;
    }
    else{
        _devicePicker.hidden=YES;
        _contentView.hidden=NO;
    }
}

- (IBAction)SaoYiSao:(id)sender {
    
    //弹出扫描界面
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    reader.showsZBarControls = YES;
    
    [self presentViewController:reader animated:YES completion:nil];
}

#pragma mark-pickView

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_deviceTypeArray count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [_deviceTypeArray objectAtIndex:row];
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        [pickerLabel setFont:[UIFont systemFontOfSize:10]];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (_deviceTypeArray!=nil&&_deviceTypeArray.count>=row) {
        [_deviceTypeButton setTitle:[_deviceTypeArray objectAtIndex:row] forState:UIControlStateNormal];
    }
    else{
        [_deviceTypeButton setTitle:@"请选择设备类型" forState:UIControlStateNormal];
    }
    _devicePicker.hidden=YES;
    _contentView.hidden=NO;
    _deviceTypeButton.selected=NO;
}

#pragma mark-二维码扫描委托
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol;
    for(symbol in results)
        break;
    
    _scanImageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    _uidCode = symbol.data;
    NSLog(@"uidcode=%@",_uidCode);
}


@end
