//
//  UserInfoViewController.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/22.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "UserInfoViewController.h"
#import "CommonDefine.h"
#import "UIWindow+YzdHUD.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(GoBack:)];
    
    self.navigationItem.leftBarButtonItem=leftBar;
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(Save:)];
    self.navigationItem.rightBarButtonItem=rightBar;
    
    self.navigationItem.title=DE_USER_INFO;
        
    //更新界面
    if(appDelegate.userInfo!=nil){
         _userTelLabel.text=appDelegate.userInfo.UserTel;
        _trueNameTextField.text=appDelegate.userInfo.TrueName;
        if (![appDelegate.userInfo.UserSex isEqualToString:@""]) {
            if ([appDelegate.userInfo.UserSex isEqualToString:@"男"]) {
                _boyButton.selected=YES;
                [_boyButton setTitle:@"√" forState:UIControlStateNormal];
                _girlButton.selected=NO;
                
            }
            else if([appDelegate.userInfo.UserSex isEqualToString:@"女"]){
                _girlButton.selected=YES;
                [_girlButton setTitle:@"√" forState:UIControlStateNormal];
                _boyButton.selected=NO;
            }
        }
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_trueNameTextField resignFirstResponder];
    [_datePicker resignFirstResponder];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark-其他操作

- (IBAction)SelectSex:(id)sender {
    UIButton *selectButton=sender;
    selectButton.selected=!selectButton.selected;
    if ([selectButton isEqual:_boyButton]) {
        if(_boyButton.selected==YES)
        {
             [_boyButton setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
            [_girlButton setBackgroundImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
            _girlButton.selected=NO;
            _userSex=@"0";
        }
        else
        {
            [_boyButton setBackgroundImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        }
        
    }
    else if ([selectButton isEqual:_girlButton]){
       
        if (_girlButton.selected==YES) {
            [_girlButton setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
            [_boyButton setBackgroundImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
            _boyButton.selected=NO;
            _userSex=@"1";
        }
        else
        {
            [_girlButton setBackgroundImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)ShowDatePicker:(id)sender {
    UIButton *btn=(UIButton*)sender;
    btn.selected=!btn.selected;
    if (btn.selected) {
        _datePicker.hidden=NO;
        [btn setTitle:@"V" forState:UIControlStateNormal];
    }
    else{
        
        NSDate *date =_datePicker.date;
        _birthdayTextField.text=[appDelegate getCurrentDate:date];
        
        _datePicker.hidden=YES;
        [btn setTitle:@"^" forState:UIControlStateNormal];
    }

}

- (IBAction)SelectDate:(id)sender {
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)Save:(id)sender {
    //请求服务器保存数据
    _command=com_updateuserinfo;
    [self PostServer];
}

- (void)GoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-网络请求

-(void)PostServer{
    
    _mData =nil;//清空数据
    _mData=[[NSMutableData alloc]init];
    
    NSString *url;
    
    NSMutableDictionary *subData=[[NSMutableDictionary alloc]init];
    NSString *loginIp=[appDelegate localIPAddress];
    
    if (_command==com_updateuserinfo) {
        url=[ServerUrl stringByAppendingString:@"/updateuserinfo"];
        [subData setObject:_trueNameTextField.text forKey:@"truename"];
        [subData setObject:_birthdayTextField.text forKey:@"birthday"];
        [subData setObject:_userSex forKey:@"usersex"];
        [subData setObject:@"" forKey:@"usermail"];
        [subData setObject:@"" forKey:@"address"];
        [subData setObject:@"" forKey:@"username"];
    }
    
    NSData *data=[appDelegate postDataWithRet:[appDelegate getRet] uid:appDelegate.userInfo.UserTel data:subData time:[appDelegate getCurrentTimeByDate:[NSDate date]] sign:@""];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    //    [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
    
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%@",response.description);
}

//接收数据完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    id data=[NSJSONSerialization JSONObjectWithData:_mData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"%@",data);
    
    if (data==nil||data ==(id)([NSNull null])){
        //LOG
        NSLog(@"数据为空");
        [self.view.window showHUDWithText:@"请求数据有误" Type:ShowPhotoNo Enabled:YES];
    }
    else{
        
//        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        
        NSString *ret=[data objectForKey:@"ret"];
        
        if (![ret isEqualToString:@"000000"]) {
            NSString *errorMes=[appDelegate getErrorMesByRet:ret];
            NSLog(@"%@",errorMes);
            [self.view.window showHUDWithText:errorMes Type:ShowPhotoNo Enabled:YES];
        }
        else{
            
            if (_command==com_updateuserinfo) {
            
                //修改userInfo信息
                if (![appDelegate.userInfo.TrueName isEqualToString:_trueNameTextField.text]) {
                     appDelegate.userInfo.TrueName=_trueNameTextField.text;
                    NSLog(@"%@",appDelegate.userInfo.TrueName);
                }
                if (![appDelegate.userInfo.UserSex isEqualToString:_userSex]) {
                    appDelegate.userInfo.UserSex=_userSex;
                    NSLog(@"%@",appDelegate.userInfo.UserSex);

                }
                if (![appDelegate.userInfo.Birthday isEqualToString:_birthdayTextField.text]) {
                    appDelegate.userInfo.Birthday=_birthdayTextField.text;
                    NSLog(@"%@",appDelegate.userInfo.Birthday);

                }
               //数据记录本地数据库
                [CottomerUser Update:appDelegate.userInfo];
                
                //返回界面
                [self.navigationController popViewControllerAnimated:YES];
            }
            
           
        }
        
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.description);
}

#pragma mark-更新用户资料





@end
