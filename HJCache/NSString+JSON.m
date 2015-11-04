//
//  NSString+JSON.m
//  MobileSiBu
//
//  Created by luo.h on 15-5-12.
//  Copyright (c) 2015年 sibu.cn. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

-(id)objectFromJSONString;
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}


-(NSData*)JSONString;
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                 
                                                options:kNilOptions error:&error];
    
    if (error != nil) return nil;
    
    return result;
}

@end
