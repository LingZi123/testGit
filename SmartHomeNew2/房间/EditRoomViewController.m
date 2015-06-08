//
//  EditRoomViewController.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/6/3.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "EditRoomViewController.h"
#import "UIWindow+YzdHUD.h"
#import "CommonDefine.h"

@interface EditRoomViewController ()

@end

@implementation EditRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationController];
    _loadingView.hidden=YES;
    [_loadingView stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithTitle:(NSString *)roomName roomId:(NSString *)roomId{
    self=[super init];
    if (self!=nil) {
        _roomname=roomName;
        _roomid=roomId;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_roomNameTextField resignFirstResponder];
}

#pragma mark-初始化界面

//初始化导航条
-(void)initNavigationController{
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"修改-%@",_roomname]];
    
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
    
    NSString *error=@"";
    if([_roomNameTextField.text isEqualToString:@""]){
        error=@"房间名不能为空";
    }
    else if ([_roomNameTextField.text isEqualToString:_roomname]){
        error=@"房间名称与之前没有变化";
    }
    
    
    if (![error isEqualToString:@""]) {
        [self.view.window showHUDWithText:error Type:ShowPhotoNo Enabled:YES];
        return;
    }
    
    _command=com_updateRoomInfo;    
    //验证，请求服务端保存
    [self PostServer];
}

#pragma mark-网络交互
-(void)PostServer{
    
    _mData =nil;//清空数据
    _mData=[[NSMutableData alloc]init];
    
    NSString *url;
    
    NSMutableDictionary *subData=[[NSMutableDictionary alloc]init];
    if (_command==com_updateRoomInfo) {
        url=[ServerUrl stringByAppendingString:@"/updateRoomInfo"];
        [subData setObject:_roomid forKey:@"roomid"];
        [subData setObject:_roomNameTextField.text forKey:@"roomname"];
    }
    
    NSData *data=[appDelegate postDataWithRet:[appDelegate getRet] uid:appDelegate.userInfo.UserTel data:subData time:[appDelegate getCurrentTimeByDate:[NSDate date]] sign:@""];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    _loadingView.hidden=NO;
    [_loadingView startAnimating];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
    
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%@",response.description);
}

//接收数据完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    [_loadingView stopAnimating];
    _loadingView.hidden=YES;
    
    id data=[NSJSONSerialization JSONObjectWithData:_mData options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"%@",data);
    
    if (data==nil||data ==(id)([NSNull null])){
        //LOG
        NSLog(@"数据为空");
        [self.view.window showHUDWithText:@"请求数据有误" Type:ShowPhotoNo Enabled:YES];
    }
    else{
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        
        NSString *ret=[dic objectForKey:@"ret"];
        
        if (![ret isEqualToString:@"000000"]) {
            NSString *errorMes=[appDelegate getErrorMesByRet:ret];
            NSLog(@"%@",errorMes);
            [self.view.window showHUDWithText:errorMes Type:ShowPhotoNo Enabled:YES];
        }
        else{
            
            if (_command==com_updateRoomInfo) {
                //返回主界面
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.description);
}


@end
