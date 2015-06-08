//
//  AddRoomViewController.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/25.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "AddRoomViewController.h"
#import "UICombox.h"
#import "CommonDefine.h"
#import "UIWindow+YzdHUD.h"
#import "RoomType.h"
#import "Tl_room_type.h"

@interface AddRoomViewController ()

@end

@implementation AddRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化界面
    [self initNavigationController];
    
    //隐藏pickview
    _roomTypePickerView.hidden=YES;
    _loadingView.hidden=YES;
    [_loadingView stopAnimating];
    
    //检查数据库中是否存在类型
    //再填充本地的数据
    [self fullRoomTyps];
    
    
    if (_roomTypeArray==nil||_roomTypeArray==(id)[NSNull null]||_roomTypeArray.count<=0) {
        //不存在从服务器中获取
        _command=com_getRoomType;
        [self PostServer];
    }
//    _roomTypeArray=[[NSArray alloc]initWithObjects:@"我的",@"你的",@"厕所",@"餐厅" ,nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_roomNameTextField resignFirstResponder];
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
    
    [self.navigationItem setTitle:@"添加房间"];
    
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
    if(_isVerty==NO)
        return;
    
    _command=com_saveRoom;
    
    //验证，请求服务端保存
    [self PostServer];
}

#pragma mark-pivew delagate

//弹出下选框
- (IBAction)_roomButtonClick:(id)sender {
    
    _roomButtonType.selected=!_roomButtonType.selected;
    if (_roomButtonType.selected) {
        _roomTypePickerView.hidden=NO;
        
        //其他控件隐藏
        _roomNameTextField.hidden=YES;
    }
    else{
        _roomTypePickerView.hidden=YES;
        _roomNameTextField.hidden=NO;
    }
}

- (IBAction)roomNameEditDidEnd:(id)sender {
    _isVerty=NO;
    _command=com_checkRoomNameIsSame;
    [self PostServer];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_roomTypeArray!=nil) {
        return [_roomTypeArray count];
    }
    else{
        return 0;
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    RoomType *type=[_roomTypeArray objectAtIndex:row];
    return type.roomname;
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
    
    if (_roomTypeArray!=nil&&_roomTypeArray.count>=row) {
        
        _selectRoomType=[_roomTypeArray objectAtIndex:row];
        
        [_roomButtonType setTitle:_selectRoomType.roomname forState:UIControlStateNormal];
        _roomImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",_selectRoomType.roomimg]];
        
    }
    else{
        [_roomButtonType setTitle:@"请选择房间类型" forState:UIControlStateNormal];
        //默认图片
    }
    _roomTypePickerView.hidden=YES;
    _roomNameTextField.hidden=NO;
    _roomButtonType.selected=NO;
}

#pragma mark-从服务器获取房间类型
-(void)PostServer{
    
    _mData =nil;//清空数据
    _mData=[[NSMutableData alloc]init];
    
    NSString *url;
    
    NSMutableDictionary *subData=[[NSMutableDictionary alloc]init];
    if (_command==com_getRoomType) {
        url=[ServerUrl stringByAppendingString:@"/getRoomType"];
    }
    else if (_command==com_saveRoom){
         url=[ServerUrl stringByAppendingString:@"/saveRoom"];
        [subData setObject:[NSString stringWithFormat:@"%@",_selectRoomType.roomtypeid]  forKey:@"roomtype"];
        [subData setObject:_roomNameTextField.text forKey:@"roomname"];
    }
    else if (_command==com_checkRoomNameIsSame){
     url=[ServerUrl stringByAppendingString:@"/checkRoomNameIsSame"];
     [subData setObject:_roomNameTextField.text forKey:@"roomname"];
    }
      
    NSData *data=[appDelegate postDataWithRet:[appDelegate getRet] uid:appDelegate.userInfo.UserTel data:subData time:[appDelegate getCurrentTimeByDate:[NSDate date]] sign:@""];
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    NSURLConnection *connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
//        [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
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
        
//        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        
        NSString *ret=[data objectForKey:@"ret"];
        
        if (![ret isEqualToString:@"000000"]) {
            NSString *errorMes=[appDelegate getErrorMesByRet:ret];
            NSLog(@"%@",errorMes);
            [self.view.window showHUDWithText:errorMes Type:ShowPhotoNo Enabled:YES];
        }
        else{
            
            
            
            if (_command==com_getRoomType) {
                //数据记录本地数据库
                NSDictionary *reciveDataDic=[data objectForKey:@"data"] ;
          
                NSLog(@"%@",reciveDataDic);
                
                NSArray *dataArray=[reciveDataDic objectForKey:@"data"];
                NSLog(@"%@",dataArray);
                
                _roomTypeArryFromServer=[[NSMutableArray alloc]init];
                
                for (id item in dataArray) {
                    
                    if (item!=nil&&item!=(id)[NSNull null]) {
                        
                        RoomType *roomtype=[[RoomType alloc]initWithContent:item];
                        roomtype.roomtypeid=[NSString stringWithFormat:@"%@",[item objectForKey:@"id"]];
                        
                        [_roomTypeArryFromServer addObject:roomtype];
                    }
                }
                
                //更新本地的房间类型
                [self updateLoaclRoomType:_roomTypeArryFromServer];
                
                [self fullRoomTyps];

            }
            else if (_command==com_saveRoom){
                //成功返回房间界面
                [self.delegate addRoomSucess];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else if (_command==com_checkRoomNameIsSame){
                _isVerty=true;
            }
        }
        
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.description);
}

#pragma mark-本地数据库操作
-(void)updateLoaclRoomType:(NSArray *)roomtypes{
    
    if (roomtypes==nil||roomtypes==(id)[NSNull null]||roomtypes.count<=0) {
        return;
    }
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    NSArray *localRoomTypes=[self getLoaclRoomTypes:nil];
    
    //对比更新
    if (localRoomTypes!=nil&&localRoomTypes!=(id)[NSNull null]&&localRoomTypes.count>0) {
        
         for (RoomType *serverType in roomtypes) {
             
             BOOL find=NO;
             for (Tl_room_type *type in localRoomTypes) {
             
                if ([type.roomtypeid isEqualToString:serverType.roomtypeid]) {
                    
                    if ([type.status isEqualToString:[NSString stringWithFormat:@"%d",1]]) {
                        type.status=[NSString stringWithFormat:@"%d",0];
                    }
                    find=true;
                    break;
                }
            }
            if (find==NO) {
                
                Tl_room_type *newtype=[NSEntityDescription insertNewObjectForEntityForName:DE_Tl_room_type inManagedObjectContext:context];
                [newtype setRoomtypeid:serverType.roomtypeid];
                [newtype setRoomname:serverType.roomname];
                [newtype setRoomimg:serverType.roomimg];
                [newtype setStatus:[NSString stringWithFormat:@"%d",0]];
            }
         }
    }
        else{
            
            for (RoomType *serverType in roomtypes) {
                Tl_room_type *newtype=[NSEntityDescription insertNewObjectForEntityForName:DE_Tl_room_type inManagedObjectContext:context];
                [newtype setRoomtypeid:serverType.roomtypeid];
                [newtype setRoomname:serverType.roomname];
                [newtype setRoomimg:serverType.roomimg];
                [newtype setStatus:[NSString stringWithFormat:@"%d",0]];
            }
            
        }
    
    NSError *error;
    if ([context save:&error]==YES) {
        NSLog(@"保存成功");
    }
    else{
        NSLog(@"保存失败");
    }
}

-(NSArray *)getLoaclRoomTypes:(NSPredicate *)predicate{
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:DE_Tl_room_type];
    if (predicate!=nil) {
         request.predicate=predicate;
    }
    
    NSError *error;
    NSArray *exeResult=[context executeFetchRequest:request error:&error];
    if (error!=nil||error!=(id)[NSNull null]) {
        NSLog(@"%@",error);
    }
    return exeResult;
}

-(void)fullRoomTyps{
    //再填充本地的数据
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"status==%@",[NSString stringWithFormat:@"%d",0]];
    
    _roomTypeArray=[[NSMutableArray alloc]init];
    
    NSArray *localTypsArray=[self getLoaclRoomTypes:pre];
    if (localTypsArray!=nil&&localTypsArray!=(id)[NSNull null]&&localTypsArray.count>0) {
        for (Tl_room_type *item in localTypsArray) {
            RoomType *typeitem=[[RoomType alloc]init];
            typeitem.roomtypeid=item.roomtypeid;
            typeitem.roomname=item.roomname;
            typeitem.roomimg=item.roomimg;
            [_roomTypeArray addObject:typeitem];
        }
    }
}

@end

