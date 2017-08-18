//
//  AdvertisingCacheManager.h
//  AdvertisingPageTest
//
//  Created by 余晔 on 2017/7/3.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kUserDefaults [NSUserDefaults standardUserDefaults]
static NSString *const adImageName = @"adImageName"; //图片名
static NSString *const adUrl = @"adUrl"; //链接名

@interface AdvertisingCacheManager : NSObject


//SDWebImageManager

+ (AdvertisingCacheManager *)shareDataManager;

/**
 *  缓存图片到内存（广告图片）
 *
 */
- (void)loadAdImageData:(NSString *)urlString;

/**
 *  图片是否依旧下载（广告图片）
 *
 */
- (BOOL)shouldLoadAdImage:(NSString *)urlString;

/**
 *  清除图片下载缓存（广告图片）
 *
 */
- (void)clearImageData:(NSString *)urlString;


/**
 *  获取已经缓存的图片（广告图片）
 *
 */
- (UIImage *)getImageData:(NSString *)urlString;






//不用SDWebImageManager
/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName;
/**
 *  删除旧图片
 */
- (void)deleteOldImage;
/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName;
/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath;

@end
