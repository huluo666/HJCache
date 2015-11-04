//
//  ViewController.m
//  HJCache
//
//  Created by luo.h on 15/11/5.
//  Copyright © 2015年 l.h. All rights reserved.
//

#import "ViewController.h"
#import "HJCache.h"

@interface ViewController ()

@end

@implementation ViewController


static NSString * const  MytableName   = @"tableName"; //最新列表

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[HJCache sharedDB] createTableWithName:MytableName];
    
    
    //插入数据
    NSDictionary *dict=@{@"kkk":@"yyyy"};
    [[HJCache sharedDB] insertObject:dict withId:@"ID" intoTable:MytableName];
    
}



/*************** READ ME ******************
 1.为保持HJCache文件整洁性,将表名集合配置文件中,根据需要添加相应数据表
 --------------------------
 2.insert  into表示插入数据，数据库会检查主键，如果出现重复会报错；
 replace into表示插入替换数据，需求表中有PrimaryKey，或者unique索引，如果数据库已经存在数据，则用新数据替换，如果没有数据效果则和insert into一样；
 3.除了Select操作之外，其它的都是更新操作。
 
 4.目前接口已满足需要,相关接口根据需要增加
 *****************************************/

@end
