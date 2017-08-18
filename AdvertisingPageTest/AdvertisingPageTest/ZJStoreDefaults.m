//
//  ZJStoreDefaults.m
//  Owner
//
//  Created by Jion on 15/12/15.
//  Copyright © 2015年 Youjuke. All rights reserved.
//

#import "ZJStoreDefaults.h"

@implementation ZJStoreDefaults
/*
 保存对象
 */
+(void)setObject:(id)obj forKey:(NSString *)key{
    if(key&&key.length>0){
        
        NSData *data= [NSKeyedArchiver archivedDataWithRootObject:obj];
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setObject:data forKey:key];
    }
}

/*
 获取对象
 */
+(id)getObjectForKey:(NSString *)key{
    if(key&&key.length>0){
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        id data = [preferences objectForKey:key];
        if ([data isKindOfClass:[NSData class]]) {
            id objc = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            return objc;
        }
     return data;
    }
    return nil;
}

/*
   移除保存的对象
 */
+(void)removeObjectForKey:(NSString *)key{
    if(key&&key.length>0){
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences removeObjectForKey:key];
    }
}

//获取缓存目录
+(NSString *)getCachesPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths lastObject];
    return libraryDirectory;
}

//创建目录
/**
 *	@brief	创建目录
 *
 *	@param 	path 	路径
 */
+(void)createPath:(NSString *)path
{
    if(path){
        if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
}
@end
