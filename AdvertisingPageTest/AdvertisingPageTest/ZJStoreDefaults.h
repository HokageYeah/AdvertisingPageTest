//
//  ZJStoreDefaults.h
//  Owner
//
//  Created by Jion on 15/12/15.
//  Copyright © 2015年 Youjuke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJStoreDefaults : NSObject
/*
 保存对象
 */
+(void)setObject:(id)obj forKey:(NSString *)key;
/*
 获取对象
 */
+(id)getObjectForKey:(NSString *)key;
/*
 移除保存的对象
 */
+(void)removeObjectForKey:(NSString *)key;

//获取缓存目录
+(NSString *)getCachesPath;
//创建目录
+(void)createPath:(NSString *)path;

@end
