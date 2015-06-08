//
//  MainViewController.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/20.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "MainViewController.h"
#import "PersonCenterViewController.h"
#import "AddRoomViewController.h"
#import "RoomViewController.h"
#import "CommonDefine.h"
#import "UIWindow+YzdHUD.h"
#import "CustomerRoom.h"
#import "EditRoomViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark-自带的方法

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;

    //初始化导航条
    [self initNavigationContrller];
    
    // 添加工具条
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self initToolBar];
    [self initPageControl:_roomPageControl];
    
    _viewWidth = self.view.frame.size.width;
    _viewHeght = self.view.frame.size.height;
    
    [self initScrollView];
    [self initPageControl:_roomPageControl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}
-(void)viewDidAppear:(BOOL)animated{
    
    _loadingView.hidden=YES;
    //根据选择按钮不同，刷新界面
    if (_roomButton.selected==YES) {
        _command=com_findRoomByUser;
        [self PostServer];
    }
    else if (_anfangButton.selected==YES){
        
    }
    else if (_changjingButton.selected==YES){
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setToolbarHidden:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    
}

#pragma mark-导航条操作

-(void)initNavigationContrller{
    
    UIBarButtonItem *leftbar=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting.png"] style:UIBarButtonItemStylePlain target:self action:@selector(Seting:)];
    self.navigationItem.leftBarButtonItem=leftbar;
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(AddRoom:)];
    self.navigationItem.rightBarButtonItem=rightBar;
    

    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationItem.title=@"房间";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nag.png"] forBarMetrics:UIBarMetricsDefault];
    
}

// 初始化工具栏
-(void)initToolBar{
    
    _roomButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    [_roomButton setImage:[UIImage imageNamed:@"fangjian.png"] forState:UIControlStateNormal];
    [_roomButton setTitle:@"房间" forState:UIControlStateNormal];
    [_roomButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    
    _roomButton.imageEdgeInsets=UIEdgeInsetsMake(-13, 0, 0, 0);
    _roomButton.titleEdgeInsets=UIEdgeInsetsMake(0, -40, -30, 0);
    [_roomButton addTarget:self action:@selector(SetRoom:) forControlEvents:UIControlEventTouchUpInside];
    
    [_roomButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithCustomView:_roomButton];
    
    _anfangButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    [_anfangButton setImage:[UIImage imageNamed:@"unanfang.png"] forState:UIControlStateNormal];
    [_anfangButton setTitle:@"安防" forState:UIControlStateNormal];
    [_anfangButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    
    _anfangButton.imageEdgeInsets=UIEdgeInsetsMake(-13, 0, 0, 0);
    _anfangButton.titleEdgeInsets=UIEdgeInsetsMake(0, -40, -30, 0);
    [_anfangButton addTarget:self action:@selector(SetAnFang:) forControlEvents:UIControlEventTouchUpInside];
    
    [_anfangButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:_anfangButton];
    
    _changjingButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    [_changjingButton setImage:[UIImage imageNamed:@"unchangjing.png"] forState:UIControlStateNormal];
    [_changjingButton setTitle:@"场景" forState:UIControlStateNormal];
    [_changjingButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    
    _changjingButton.imageEdgeInsets=UIEdgeInsetsMake(-13, 0, 0, 0);
    _changjingButton.titleEdgeInsets=UIEdgeInsetsMake(0, -40, -30, 0);
    [_changjingButton addTarget:self action:@selector(SetChangJing:) forControlEvents:UIControlEventTouchUpInside];
    [_changjingButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
     

    UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithCustomView:_changjingButton];
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
     
    NSArray *items=[[NSArray alloc]initWithObjects:flexItem,item1,flexItem,item2,flexItem,item3,flexItem, nil];
    
    self.toolbarItems=items;
    [self SetRoom:_roomButton];
    
}

//设置
- (void)Seting:(id)sender {
    PersonCenterViewController *personCenterVC=[[PersonCenterViewController alloc]init];
    [self.navigationController pushViewController:personCenterVC animated:YES];
}
//设置房间
- (void)SetRoom:(id)sender {
  // 修改选中颜色
    [_roomButton setImage:[UIImage imageNamed:@"fangjian.png"] forState:UIControlStateNormal ];

    [_anfangButton setImage:[UIImage imageNamed:@"unanfang.png"] forState:UIControlStateNormal];
    [_changjingButton setImage:[UIImage imageNamed:@"unchangjing.png"] forState:UIControlStateNormal];
    
    _roomButton.selected=YES;
    _anfangButton.selected=NO;
    _changjingButton.selected=NO;
    
  //进入添加房间的列表
    _roomScrollView.hidden=NO;
    _safeScrollView.hidden=YES;
    _scenceScrollView.hidden=YES;
    
    [self.navigationItem.rightBarButtonItem setTitle:@"添加"];
}

- (void)SetAnFang:(id)sender {
    // 修改选中的颜色进入安防的界面
    [_roomButton setImage:[UIImage imageNamed:@"unfangjian.png"] forState:UIControlStateNormal];
    [_anfangButton setImage:[UIImage imageNamed:@"anfang.png"] forState:UIControlStateNormal];
    [_changjingButton setImage:[UIImage imageNamed:@"unchangjing.png"] forState:UIControlStateNormal];
    _roomScrollView.hidden=YES;
    _safeScrollView.hidden=NO;
    _scenceScrollView.hidden=YES;
    _roomButton.selected=NO;
    _anfangButton.selected=YES;
    _changjingButton.selected=NO;
}

- (void)SetChangJing:(id)sender {
    //修改选中的颜色进入场景的界面
    [_roomButton setImage:[UIImage imageNamed:@"unfangjian.png"] forState:UIControlStateNormal];
    [_anfangButton setImage:[UIImage imageNamed:@"unanfang.png"] forState:UIControlStateNormal];
    [_changjingButton setImage:[UIImage imageNamed:@"changjing.png"] forState:UIControlStateNormal];
    _roomScrollView.hidden=YES;
    _safeScrollView.hidden=YES;
    _scenceScrollView.hidden=NO;
    _roomButton.selected=NO;
    _anfangButton.selected=NO;
    _changjingButton.selected=YES;
    [self.navigationItem.rightBarButtonItem setTitle:@"添加"];


}

#pragma mark-其它按钮操作

//添加房间
- (IBAction)AddRoom:(id)sender {

    if (_roomButton.selected) {
         AddRoomViewController *VC=[[AddRoomViewController alloc]init];
        VC.delegate=self;
        [self.navigationController pushViewController:VC animated:YES];

    }
   
//    }
//    else if (btn.tag==10001){
//        //进入安防
//    }
//    else if (btn.tag==10002){
//        //进入情景模式
//    }
//    else if (btn.tag<100){
//        //进入拥有电器的房间
//        VC=[[RoomViewController alloc]init];
//    }
//    else if (btn.tag>=100&&btn.tag<1000){
//        //进入安防的
//    }
//    else {
//        //进入情景模式
//    }
   }

#pragma mark-刷新页面 

-(void)initScrollView{
    _roomScrollView.delegate=self;
    _roomScrollView.contentSize=CGSizeMake(_viewWidth, 0);
    _safeScrollView.delegate=self;
    _scenceScrollView.delegate=self;
}
-(void)initPageControl:(id)sender{
    UIPageControl *curentPageControl=(UIPageControl *)sender;
    curentPageControl.pageIndicatorTintColor=[UIColor grayColor];//非选中的原点颜色
    curentPageControl.currentPageIndicatorTintColor=[UIColor blueColor];//选中的点的颜色
    curentPageControl.enabled=NO;
    curentPageControl.numberOfPages=1;
}

-(void)refashRoomView{
    
    //清空界面
    [self removeAllObject:_roomScrollView];
    
    if (_roomArray==nil||_roomArray==(id)[NSNull null]||_roomArray.count<=0) {
        return;
    }
    
     _roomPageCount=0;
    
    _roomPageControl.numberOfPages=_roomArray.count%9==0?_roomArray.count/9:_roomArray.count/9+1;
    
    _roomScrollView.contentSize=CGSizeMake(_roomPageControl.numberOfPages*_viewWidth, 0);
    
    for (int i=0; i<_roomArray.count; i++) {
        
        _roomPageCount=i/9;
        
        CustomerRoom *room=_roomArray[i];
        
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(kIphoneaddButtonX+i%3*kIphoneaddButtonXGap+_roomPageCount*kDeviceWidth, kIphoneaddButtonY+i/3%3*kIphoneaddButtonYGap, kIphoneaddButtonWidth,kIphoneaddButtonHeight);

        
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",room.roomImage]] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.tag=i;
        
       
        UILongPressGestureRecognizer *longPressGR =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(longRoomPress:)];
        
        longPressGR.minimumPressDuration = 0.5;
        [btn addGestureRecognizer:longPressGR];
        
        
        UILabel *desLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+btn.frame.size.height+5, btn.frame.size.width, 20)];
        [desLabel setText:room.roomname];
        [desLabel setFont:[UIFont systemFontOfSize:12]];
        [desLabel setTextColor:[UIColor grayColor]];
        [desLabel setTextAlignment:NSTextAlignmentCenter];
        
        [_roomScrollView addSubview:btn];
        [_roomScrollView addSubview:desLabel];

    }
}

-(void)longRoomPress:(UILongPressGestureRecognizer *)gesture
{
    _selectButton=(UIButton *)[gesture view];
//    UIButton *pressedBtn=(UIButton *)[gesture view];
    
    NSInteger tag=_selectButton.tag;
    
    NSString *alertTitle=@"提示";
    //卧室
    if (tag<100) {
        _selectRoom= [_roomArray objectAtIndex:tag];
        alertTitle=_selectRoom.roomname;
    }
    else if(tag>=100&&tag<200){
        //安防
        
    }
    else if (tag>=200&&tag<300){
        //场景
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
       //弹出提示框
        if (_selectRoomAlertView==nil||_selectRoomAlertView==(id)[NSNull null]) {
            _selectRoomAlertView=[[UIAlertView alloc]initWithTitle:alertTitle message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",@"修改", nil];
            _selectRoomAlertView.delegate=self;
        }
        [_selectRoomAlertView setTitle:alertTitle];
        [_selectRoomAlertView show];
    }
}

-(void)hiddenLoading{
    _loadingView.hidden=YES;
    [_loadingView stopAnimating];
}
-(void)startLoading{
    _loadingView.hidden=NO;
    [_loadingView startAnimating];
}

//去掉view的所有画面
-(void)removeAllObject:(UIScrollView *)view{
    
    for (id obj in view.subviews){
        if (obj == _roomPageControl) {
            continue;
        }
        [obj removeFromSuperview];
    }
}

//btn事件
-(void)btnClick:(id)sender{
    
    UIButton *btn=(UIButton *)sender;
    
    UIViewController *VC=nil;
    
    if (btn.tag==10001){
        //进入安防
    }
    else if (btn.tag==10002){
        //进入情景模式
    }
    else if (btn.tag<100){
        //进入拥有电器的房间
        VC=[[RoomViewController alloc]init];
    }
    else if (btn.tag>=100&&btn.tag<1000){
        //进入安防的
    }
    else {
        //进入情景模式
    }
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 设置页码
    _roomPageControl.currentPage=page;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    
//    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
//    
//    // 设置页码
//    _roomPageControl.currentPage=page;
}

#pragma mark-网络请求

-(void)PostServer{
    
    _mData =nil;//清空数据
    _mData=[[NSMutableData alloc]init];
    
    NSString *url;
    
    NSMutableDictionary *subData=[[NSMutableDictionary alloc]init];
    
    
    if (_command==com_findRoomByUser) {
        url=[ServerUrl stringByAppendingString:@"/findRoomByUser"];
    }
    else if (_command==com_delRoom){
        url=[ServerUrl stringByAppendingString:@"/delRoom"];
        [subData setObject:_selectRoom.roomid forKey:@"roomid"];
    }
        
    NSData *data=[appDelegate postDataWithRet:[appDelegate getRet] uid:appDelegate.userInfo.UserTel data:subData time:[appDelegate getCurrentTimeByDate:[NSDate date]] sign:@""];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    [self startLoading];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
    
    
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%@",response.description);
}

//接收数据完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self hiddenLoading];
    
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
            
            if (_command==com_findRoomByUser) {
                
                NSDictionary *reciveDataDic=[data objectForKey:@"data"] ;
                
                NSLog(@"%@",reciveDataDic);
                
                NSArray *dataArray=[reciveDataDic objectForKey:@"data"];
                NSLog(@"%@",dataArray);

                //刷新界面
                //数据记录本地数据库
                if (_roomArray==nil) {
                    _roomArray=[[NSMutableArray alloc]init];
                }
                else{
                    [_roomArray removeAllObjects];
                }
                
                if (dataArray!=nil&&dataArray!=(id)[NSNull null]&&dataArray.count>0) {
                    
                    for (id item in dataArray) {
                        
                        CustomerRoom *room =[[CustomerRoom alloc]initWithContent:item];
                        room.roomid=[NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                        room.roomtype=[NSString stringWithFormat:@"%@",[item objectForKey:@"roomtype"]];
                        
                        [_roomArray addObject:room];
                    }
                }
                
                
               
                [self refashRoomView];
            }
            else if (_command==com_delRoom){
                //删除房间
                
                //移除当前选中的button和清除model
//                [self deleteRoom];
//                [self.view.window showHUDWithText:@"删除房间成功" Type:ShowPhotoYes Enabled:YES];
                
                //重新从服务器拉
                
                _command=com_findRoomByUser;
                [self PostServer];
            }
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [self hiddenLoading];
    NSLog(@"%@",error.description);
    [self.view.window showHUDWithText:@"网络错误" Type:ShowPhotoNo Enabled:YES];
}

#pragma mark-添加房间委托
-(void)addRoomSucess{
    
   
    
}

-(void)deleteRoom{
    [_selectButton removeFromSuperview];
    if (_roomButton.selected) {
        _selectRoom=nil;
    }
}

#pragma mark-弹出框委托
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //取消
    if(buttonIndex==0){
        
    }
    //删除
    else if(buttonIndex==1){
        if (_roomButton.selected) {
            //删除房间
            _command=com_delRoom;
        }
        else if (_anfangButton.selected){
            
        }
        else if (_changjingButton.selected){
            
        }
        [self PostServer];
    }
    //修改
    else{
        
        if (_roomButton.selected) {
            //进入修改房间的修改该房间
            EditRoomViewController *editRoomVC=[[EditRoomViewController alloc]initWithTitle:_selectRoom.roomname roomId:_selectRoom.roomid];
            
            [self.navigationController pushViewController:editRoomVC animated:YES];
            
        }
        else if (_anfangButton.selected){
            
        }
        else if (_changjingButton.selected){
            
        }
    }
}

@end
