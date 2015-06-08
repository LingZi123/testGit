//
//  RoomViewController.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/27.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "RoomViewController.h"
#import "AddDeviceViewController.h"
#import "CommonDefine.h"

@interface RoomViewController ()

@end

@implementation RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationController];
    
    _viewWidth = self.view.frame.size.width;
    _viewHeght = self.view.frame.size.height;
    
    [self initScrollView];
    [self initPageControl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{

    
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
    
    [self.navigationItem setTitle:@"房间名称"];
    
    UIBarButtonItem *leftBar=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(GoBack:)];
    
    self.navigationItem.leftBarButtonItem=leftBar;
    
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@" 添加设备" style:UIBarButtonItemStylePlain target:self action:@selector(AddDeviceClick:)];
    
    self.navigationItem.rightBarButtonItem=rightBar;
}


#pragma mark-导航条

-(void)GoBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)AddDeviceClick:(id)sender {
    AddDeviceViewController *addDeviceVC=[[AddDeviceViewController alloc]init];
    
    [self.navigationController pushViewController:addDeviceVC animated:YES];
}

-(void)initScrollView{
    _deviceScrollView.delegate=self;
    _deviceScrollView.contentSize=CGSizeMake(_viewWidth, 0);

}
-(void)initPageControl{
    _pageControl.pageIndicatorTintColor=[UIColor grayColor];//非选中的原点颜色
    _pageControl.currentPageIndicatorTintColor=[UIColor blueColor];//选中的点的颜色
    _pageControl.enabled=NO;
    _pageControl.numberOfPages=1;
}

-(void)refashRoomView{
    
    //清空界面
    [self removeAllObject:_deviceScrollView];
    
    if (_deviceArray==nil||_deviceArray==(id)[NSNull null]||_deviceArray.count<=0) {
        return;
    }
    
    NSInteger devicePageCount=0;
    
    _pageControl.numberOfPages=_deviceArray.count%9==0?_deviceArray.count/9:_deviceArray.count/9+1;
    
    _deviceScrollView.contentSize=CGSizeMake(_pageControl.numberOfPages*_viewWidth, 0);
    
    for (int i=0; i<_deviceArray.count; i++) {
        
        devicePageCount=i/9;
        
//        CustomerRoom *room=_roomArray[i];
        
        UIButton *btn = [[UIButton alloc]init];
//        btn.frame = CGRectMake(kIphoneaddButtonX+i%3*kIphoneaddButtonXGap+_roomPageCount*kDeviceWidth, kIphoneaddButtonY+i/3%3*kIphoneaddButtonYGap, kIphoneaddButtonWidth,kIphoneaddButtonHeight);
        
        
//        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",room.roomImage]] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        btn.tag=i;
        
        
        UILongPressGestureRecognizer *longPressGR =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(longRoomPress:)];
        
        longPressGR.minimumPressDuration = 0.5;
        [btn addGestureRecognizer:longPressGR];
        
        
        UILabel *desLabel=[[UILabel alloc]initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+btn.frame.size.height+5, btn.frame.size.width, 20)];
//        [desLabel setText:room.roomname];
        [desLabel setFont:[UIFont systemFontOfSize:12]];
        [desLabel setTextColor:[UIColor grayColor]];
        [desLabel setTextAlignment:NSTextAlignmentCenter];
        
        [_deviceScrollView addSubview:btn];
        [_deviceScrollView addSubview:desLabel];
        
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
//        _selectRoom= [_roomArray objectAtIndex:tag];
//        alertTitle=_selectRoom.roomname;
    }
    else if(tag>=100&&tag<200){
        //安防
        
    }
    else if (tag>=200&&tag<300){
        //场景
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        //弹出提示框
        if (_deviceAlertView==nil||_deviceAlertView==(id)[NSNull null]) {
            _deviceAlertView=[[UIAlertView alloc]initWithTitle:alertTitle message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除",@"修改", nil];
            _deviceAlertView.delegate=self;
        }
        [_deviceAlertView setTitle:alertTitle];
        [_deviceAlertView show];
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
    _pageControl.currentPage=page;
}


@end
