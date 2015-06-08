//
//  HelpViewController.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/25.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "HelpViewController.h"
#import "CommonDefine.h"
#import "UIWindow+YzdHUD.h"
#import "AppHelp.h"
#import "App_help.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationController];
    
    _command=com_findHelp;
    _groupArray=[self getHelpByLocal];// 从本地获取
   
    //从服务器拿数据
    if (_groupArray==nil) {
        [self PostServer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark- 导航栏事件

-(void)initNavigationController{
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(GoBack:)];
    self.navigationItem.leftBarButtonItem=leftBar;
    self.navigationItem.title=DE_Kefu_Center;
}

-(void)GoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-网络请求

-(void)PostServer{
    
    _mData =nil;//清空数据
    _mData=[[NSMutableData alloc]init];
    
    NSString *url;
    
    NSMutableDictionary *subData=[[NSMutableDictionary alloc]init];
    
    if (_command==com_findHelp) {
        url=[ServerUrl stringByAppendingString:@"/findHelp"];
        [subData setObject:@"1" forKey:@"ostype"];
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
            
            if (_command==com_findHelp) {
                
                NSDictionary *reciveDataDic=[data objectForKey:@"data"] ;
                
                NSLog(@"%@",reciveDataDic);
                
                NSArray *dataArray=[reciveDataDic objectForKey:@"data"];
                NSLog(@"%@",dataArray);
                
                if (dataArray!=nil&&dataArray!=(id)[NSNull null]&&dataArray.count>0) {
                    
                    _groupArray=[[NSMutableArray alloc]init];
                    
                    for (id item in dataArray) {

                        AppHelp *model=[[AppHelp alloc]initWithContent:item];
                        model.helpid=[NSString stringWithFormat:@"%@",
                                      [item objectForKey:@"id"]];
                        [_groupArray addObject:model];
                    }
                    
                    //更新本地数据库
                    [AppHelp  AddHelp:_groupArray];
                    
                    //更新显示
                    [_helpTableView reloadData];
                    

                }
            }
            
        }
        
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.description);
}

#pragma mark-数据库操作
-(NSMutableArray *)getHelpByLocal{
    NSMutableArray *result=nil;
    NSArray *loacalhelp=[AppHelp queryAllHelp];
    if (loacalhelp!=nil&&loacalhelp!=(id)[NSNull null]&&loacalhelp.count>0) {
        
        result=[[NSMutableArray alloc]init];
        for (App_help *item in loacalhelp) {
            AppHelp *newitem=[[AppHelp alloc]init];
            newitem.stitle=item.stitle;
            newitem.helpdec=item.helpdec;
            [result addObject:newitem];
        }
    }
    return  result;
}

#pragma mark-tableview委托
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_groupArray!=nil||_groupArray!=(id)[NSNull null]||_groupArray.count<=0) {
        return 0;
    }
    else{
        return  [_groupArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppHelp *selectModel=_groupArray[indexPath.section];
    
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    cell.textLabel.text=selectModel.helpdec;
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
     AppHelp *selectModel=_groupArray[section];
    return  selectModel.stitle;
}

@end
