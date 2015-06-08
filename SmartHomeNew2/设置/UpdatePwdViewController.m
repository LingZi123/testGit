//
//  UpdatePwdViewController.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/22.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "UpdatePwdViewController.h"
#import "CommonDefine.h"
#import "UIWindow+YzdHUD.h"

@interface UpdatePwdViewController ()

@end

@implementation UpdatePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self initNavigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_oldPwdTextField resignFirstResponder];
    [_newPwdTextField resignFirstResponder];
    [_newOncePwdTextField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark-导航条

//初始化导航条
-(void)initNavigationController{
    
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(GoBack:)];
    
    self.navigationItem.leftBarButtonItem=leftBar;
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(Save:)];
    self.navigationItem.rightBarButtonItem=rightBar;
    
    self.navigationItem.title=DE_UPDATE_PWD;

}

- (void)GoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)Save:(id)sender {
    
    //请求服务端保存数据
    if (_oldPwdOk&&_newOncePwdOk&&_newPwdOk) {
        _command=com_updatepass;
        [self PostServer];
    }
}

#pragma mark-输入验证

- (IBAction)OldPwdEditDidEnd:(id)sender {
    //验证旧密码是否正确
    NSString *errorMes=[appDelegate VertyPassword:_oldPwdTextField.text];
    
    if ([errorMes isEqualToString:@""]) {
        //和旧密码是否一致
        _oldPwdOk=YES;
    }
    else{
        [self.view.window showHUDWithText:errorMes Type:ShowPhotoNo Enabled:YES];
    }
    
}

- (IBAction)NewPwdEditDidEnd:(id)sender {
    //新密码格式
    NSString *errorMes=[appDelegate VertyPassword:_oldPwdTextField.text];
    
    if ([errorMes isEqualToString:@""]) {
        _newPwdOk=YES;
    }
    else{
        [self.view.window showHUDWithText:errorMes Type:ShowPhotoNo Enabled:YES];
        
    }

}

- (IBAction)NewPwdOnceEditDidEnd:(id)sender {
    // 新密码格式
    NSString *errorMes=[appDelegate VertyPassword:_oldPwdTextField.text];
    
    if ([errorMes isEqualToString:@""]) {
    
        // 是否和前一次输入的密码一致
        if ([_newOncePwdTextField.text isEqualToString:_newOncePwdTextField.text]) {
            _newOncePwdOk=YES;
        }
    }
    else{
         [self.view.window showHUDWithText:errorMes Type:ShowPhotoNo Enabled:YES];
    }
}

#pragma mark-网络请求

-(void)PostServer{
    
    _mData =nil;//清空数据
    _mData=[[NSMutableData alloc]init];
    
    NSString *url;
    
    NSMutableDictionary *subData=[[NSMutableDictionary alloc]init];
    NSString *loginIp=[appDelegate localIPAddress];
    
    if (_command==com_updatepass) {
        url=[ServerUrl stringByAppendingString:@"/updatepass"];
        [subData setObject:_oldPwdTextField.text forKey:@"oldpwd"];
        [subData setObject:_newOncePwdTextField.text forKey:@"newpwd"];
    }
    
    NSData *data=[appDelegate postDataWithRet:[appDelegate getRet] uid:appDelegate.userInfo.UserTel data:subData time:[appDelegate getCurrentTimeByDate:[NSDate date]] sign:@""];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];

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
            
            if (_command==com_updatepass) {
                
                //数据记录本地数据库
                appDelegate.userInfo.UserPass=_newOncePwdTextField.text;
                
                //更新数据库
                
                NSInteger isupdate=[CottomerUser Update:appDelegate.userInfo];
                
                if (isupdate==2) {
                    NSLog(@"更新失败");
                }
            }
            
        }
        
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.description);
}


@end
