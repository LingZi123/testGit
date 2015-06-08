//
//  PersonCenterViewController.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/22.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandEnum.h"


@interface PersonCenterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *_dataTV;
    NSArray *_dataArray;//填充tableview的内容
    CommandType _command;//命令
    NSMutableData *_mData;//接收的网络数据
    
}
- (IBAction)GoBack:(id)sender;//返回
- (IBAction)Logout:(id)sender;//注销登录

@end
