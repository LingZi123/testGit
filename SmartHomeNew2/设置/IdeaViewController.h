//
//  IdeaViewController.h
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/5/25.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommandEnum.h"

@interface IdeaViewController : UIViewController{
    
    IBOutlet UITextView *_ideaTextView;
    CommandType _command;
    NSMutableData *_mData;
}

@end
