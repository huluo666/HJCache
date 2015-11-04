//
//  NSString+JSON.h
//  MobileSiBu
//
//  Created by luo.h on 15-5-12.
//  Copyright (c) 2015年 sibu.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)
/**
 *  字符串转字典（替换jsonkit）
 *
 *  @return id（NSDictionary）
 */
- (id)objectFromJSONString;

/**
 *  字符串转NSData
 *
 *  @return NSData
 */
-(NSData*)JSONString;

@end
