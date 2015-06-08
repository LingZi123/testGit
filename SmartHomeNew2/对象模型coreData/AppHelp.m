//
//  AppHelp.m
//  SmartHomeNew2
//
//  Created by 卓哥的世界你不懂 on 15/6/4.
//  Copyright (c) 2015年 stone. All rights reserved.
//

#import "AppHelp.h"
#import "App_help.h"
#import "CommonDefine.h"

@implementation AppHelp

- (id)mapAttributes
{
    NSDictionary *mapDic = @{
                             @"helpid":@"id",
                             @"stitle":@"stitle",
                             @"helpdec":@"helpdec",

                             };
    return mapDic;
}

+(BOOL)AddHelp:(NSArray *)newHelpModelArrays{
   
    BOOL result=NO;
    
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    
    //查找所有的数据
    NSArray *extReArray=[self queryAllHelp];
    
    if (newHelpModelArrays==nil||newHelpModelArrays==(id)[NSNull null]||newHelpModelArrays.count<=0) {
        result=YES;
        
//        //移除所有的数据
//        if (extReArray==nil||extReArray==(id)[NSNull null]||extReArray.count<=0) {
//            result=YES;
//        }
//        else{
//            // 删除
//            
//            for (App_help *item in extReArray) {
//                [context deleteObject:item];
//            }
//        }
    }
    else {
        //遍历传入的值，本地数据库是否存在，不存在就添加
        if (extReArray==nil||extReArray==(id)[NSNull null]||extReArray.count<=0) {
            for (AppHelp *newModel in newHelpModelArrays) {
            
                App_help *addModel=[NSEntityDescription insertNewObjectForEntityForName:DE_App_help inManagedObjectContext:context];
                
                [addModel setHelpid:newModel.helpid];
                [addModel setHelpdec:newModel.helpdec];
                [addModel setStitle:newModel.stitle];
            }

        }
        else{
            for (AppHelp *newModel in newHelpModelArrays) {
                
                BOOL find=NO;
                for (App_help *item in extReArray) {
                    
                    if ([item.helpid isEqualToString:newModel.helpid]) {
                        find=YES;
                        break;
                    }
                }
                if (find==NO) {
                    App_help *addModel=[NSEntityDescription insertNewObjectForEntityForName:DE_App_help inManagedObjectContext:context];
                    
                    [addModel setHelpid:newModel.helpid];
                    [addModel setHelpdec:newModel.helpdec];
                    [addModel setStitle:newModel.stitle];

                }
            }

        }
        NSError *error;
        result=[context save:&error];
        if (result==NO) {
            NSLog(@"%@",error);
        }
    }
    
    return result;
}

-(void)deleteHelp:(App_help *)model{
//    NSManagedObjectContext *context=
}

+(NSArray *)queryAllHelp{
    NSManagedObjectContext *context=appDelegate.managedObjectContext;
    
    NSFetchRequest *request=[[NSFetchRequest alloc]initWithEntityName:DE_App_help];
    NSError *error;
    NSArray *exeArray=[context executeFetchRequest:request error:&error];
    
    return  exeArray;
}
@end
