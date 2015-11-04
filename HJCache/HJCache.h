//
//  HJCache.h
//  HJCache
//
//  Created by luo.h on 15/11/5.
//  Copyright © 2015年 l.h. All rights reserved.
//
//  PS：添加 libsqlite3.dylib 依赖库
#import <Foundation/Foundation.h>

@interface HJCache : NSObject
@property(nonatomic,strong) NSString    *dataPath;


+(HJCache *)sharedDB;

/**
 *  创建表
 *
 *  @param tableName 表名
 */
- (void)createTableWithName:(NSString *)tableName;

/**
 *  插入数据
 */
- (void)insertObject:(NSDictionary*)dict withId:(NSString *)objId intoTable:(NSString *)tableName;

/**
 *  查询数据
 */

-(BOOL)executeQueryWithId:(NSString *)objId fromTable:(NSString *)tableName;

/**
 *  更新数据
 *
 */
-(void)updateWithJSONDict:(NSDictionary *)dict andID:(NSString*)objId fromTable:(NSString *)tableName;

/**
 *  查询所有数据
 *
 */
-(NSArray *)selectAllRecordsToModel:(Class)className  fromTable:(NSString *)tableName;


//删除操作
- (void)deleteRecordWithId:(NSString *)objId fromTable:(NSString *)tableName;



#pragma mark----删除数据库
//删除数据库文件
-(void)clearDisk;

//缓存大小
- (long long) getSize;


@end
