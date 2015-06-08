//
//  IdeaViewController.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/25.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "IdeaViewController.h"
#import "CommonDefine.h"
#import "UIWindow+YzdHUD.h"

@interface IdeaViewController ()

@end

@implementation IdeaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationController];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    _ideaTextView.layer.borderWidth=1;
    _ideaTextView.layer.borderColor=[UIColor grayColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_ideaTextView resignFirstResponder];
}

#pragma mark- 导航栏事件

-(void)initNavigationController{
    
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(GoBack:)];
    
    self.navigationItem.leftBarButtonItem=leftBar;
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(Save:)];
    self.navigationItem.rightBarButtonItem=rightBar;
    
    self.navigationItem.title=DE_IDEA;

}
-(void)GoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)Save:(id)sender{
    
    //请求服务器保存
    _command=com_saveFeedback;
    [self PostServer];
}

#pragma mark-网络请求

-(void)PostServer{
    
    _mData =nil;//清空数据
    _mData=[[NSMutableData alloc]init];
    
    NSString *url;
    
    NSMutableDictionary *subData=[[NSMutableDictionary alloc]init];
    NSString *loginIp=[appDelegate localIPAddress];
    
    if (_command==com_saveFeedback) {
        url=[ServerUrl stringByAppendingString:@"/saveFeedback"];
        [subData setObject:_ideaTextView.text forKey:@"msg"];
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
            
            if (_command==com_saveFeedback) {
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        }
        
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.description);
}



@end
