//
//  HJCache.m
//  HJCache
//
//  Created by luo.h on 15/11/5.
//  Copyright © 2015年 l.h. All rights reserved.
//

#import "HJCache.h"
#import "NSString+JSON.h"
#import "MJExtension.h"

#import "FMDatabaseQueue.h"
#import "FMDatabase.h"


static NSString *const CREATE_TABLE_SQL =
@"CREATE TABLE IF NOT EXISTS %@ ( \
News_ID TEXT NOT NULL, \
JSONString TEXT NOT NULL, \
PRIMARY KEY(News_ID)) \
";

@implementation HJCache
{
    FMDatabaseQueue *_dbQueue;
}

+(HJCache *)sharedDB
{
    static HJCache *_sharedObject = nil;
    if(!_sharedObject)
    {
        _sharedObject = [[HJCache alloc] init];
    }
    return _sharedObject;
}


//获取db的路径   建立数据库
-(NSString *)dataPath
{
    if (!_dataPath) {
        NSString* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        _dataPath= [documentPath stringByAppendingPathComponent:@"mobileSiBuNewsDB.db"];
    }
    return _dataPath;
}


//初始化
-(id)init
{
    if( self = [super init])
    {
        [self creatDatabase];//_dbQueue 初始化
    }
    return self;
}


//获取db的路径   建立数据库
-(void)creatDatabase
{
    _dbQueue=[FMDatabaseQueue databaseQueueWithPath:self.dataPath];
}



/**
 *  创建表
 *
 *  @param tableName 表名
 */
- (void)createTableWithName:(NSString *)tableName {
    NSAssert(tableName != nil, @"tableName not nil");
    
    NSString * sql = [NSString stringWithFormat:CREATE_TABLE_SQL, tableName];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if(![db executeUpdate:sql]) {
            NSLog(@"ERROR, Failed To Create Table: %@", tableName);
        }else {
            NSLog(@"Sucess To Create Table: %@", tableName);
        }
    }];
}


#pragma mark-增删改都可调用的执行语句
-(void)executeUpdateWithSQL:(NSString *)sql fromTable:(NSString *)tableName;
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if(![db executeUpdate:sql]){
            NSLog(@"ERROR,Failed To executeUpdate Table %@",tableName);
        }else {
            NSLog(@"Sucess To executeUpdate Table: %@", tableName);
        }
    }];
}


/**
 *  增加一条记录
 *
 *  @param dict      NSDictionary
 *  @param objId     记录ID号
 *  @param tableName 表名
 */
- (void)insertObject:(NSDictionary*)dict withId:(NSString *)objId intoTable:(NSString *)tableName
{
    NSString *jsonStr=[dict JSONString];
    NSString  *insertSQl=[NSString stringWithFormat:@"replace into '%@' (News_ID,JSONString) values ('%@','%@') ",tableName,objId,jsonStr];
    [self executeUpdateWithSQL:insertSQl fromTable:tableName];
}

#pragma mark--- 查询操作 判断是否包含此新闻视频ID
/**
 *  查询是否包含此ID记录
 *
 *  @param objId     记录ID号
 *  @param tableName 表名
 *
 *  @return BOOL
 */
-(BOOL)executeQueryWithId:(NSString *)objId fromTable:(NSString *)tableName
{
    __block   NSInteger result = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString  *sql=[NSString  stringWithFormat:@"select  *FROM %@  WHERE News_ID =%@",tableName,objId];
        FMResultSet *rs=[db executeQuery:sql];
        while ([rs next]) {
            result=[rs intForColumnIndex:0];
        }
    }];
    return result;
}



/**
 *  更新指定ID
 *
 *  @param dict
 *  @param objId     NSDictionary
 *  @param tableName 表名
 */
-(void)updateWithJSONDict:(NSDictionary *)dict andID:(NSString*)objId fromTable:(NSString *)tableName
{
    NSString *jsonStr=[dict JSONString];
    NSString *updateSQL = [NSString stringWithFormat:@"update %@ set JSONString = '%@' where News_ID = %@",tableName ,jsonStr,objId];
    [self executeUpdateWithSQL:updateSQL fromTable:tableName];
}



/**
 *  查询所有记录
 *
 *  @param className 模型
 *  @param tableName 表名
 *
 *  @return 模型数组
 */
-(NSArray *)selectAllRecordsToModel:(Class)className  fromTable:(NSString *)tableName
{
    __block NSMutableArray *searchArray = [[NSMutableArray alloc]init];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:[NSString stringWithFormat:@"select *from %@  order by News_ID DESC",tableName]];
        while ([resultSet next])
        {
            NSString   *JSONString= [resultSet stringForColumn:@"JSONString"];
            NSDictionary *jsondict =[JSONString objectFromJSONString];
            id obj = [className objectWithKeyValues:jsondict];
            [searchArray addObject:obj];
        }
    }];
    NSLog(@"searchArray---%@",searchArray);
    return searchArray;
}


/**
 *  查询指定ID
 */
-(id)selecRecordWithId:(NSString *)objId ToModel:(Class)className fromTable:(NSString *)tableName
{
    __block   id result=nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString  *sql=[NSString  stringWithFormat:@"select  *FROM %@  WHERE News_ID =%@",tableName,objId];
        FMResultSet *resultSet=[db executeQuery:sql];
        while ([resultSet next]) {
            NSString   *JSONString= [resultSet stringForColumn:@"JSONString"];
            NSDictionary *jsondict =[JSONString objectFromJSONString];
            result = [className objectWithKeyValues:jsondict];
        }
    }];
    return result;
}

- (void)deleteRecordWithId:(NSString *)objId fromTable:(NSString *)tableName
{
    NSString  *deleteSQl=[NSString stringWithFormat:@"DELETE from %@ where id = %@",tableName,objId];
    [self executeUpdateWithSQL:deleteSQl fromTable:tableName];
}

//删除数据库文件
-(void)clearDisk
{
    NSError *error;
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    BOOL  isDelete=[defaultManager removeItemAtPath:self.dataPath error:&error];
    if (isDelete) {
        NSLog(@"删除数据库成功");
    }else{
        NSLog(@"删除数据库错误%@",error);
    }
}

//缓存文件大小
- (long long) getSize{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.dataPath]){
        return [[manager attributesOfItemAtPath:self.dataPath error:nil] fileSize];
    }
    return 0;
}

@end
