# HJCache
利用FMDB缓存JSON数据,无需写Sql语句,自动进行模型转换，特别适合新闻类应用进行本地缓存


``` objc
    //创建表
    [[HJCache sharedDB] createTableWithName:@"tableName"];
    
    //插入数据
     NSDictionary *dict=@{@"kkk":@"yyyy"};
    [[HJCache sharedDB] insertObject:dict withId:@"ID" intoTable:@"tableName"];
    
    //查询所有数据——》model
     NSArray *array =[[HJCache sharedDB] selectAllRecordsToModel:yourmodel fromTable:@"tableName"];
```
##其它相关操作请查看API

