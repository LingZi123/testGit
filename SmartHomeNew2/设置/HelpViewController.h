//
//  HelpViewController.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/25.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandEnum.h"

@interface HelpViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    

    IBOutlet UITableView *_helpTableView;
    CommandType _command;
    NSMutableData *_mData;
    NSMutableArray *_groupArray;
}

@end
