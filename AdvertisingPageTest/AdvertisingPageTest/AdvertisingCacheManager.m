//
//  AdvertisingCacheManager.m
//  AdvertisingPageTest
//
//  Created by 余晔 on 2017/7/3.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import "AdvertisingCacheManager.h"
#import "SDWebImageManager.h"

@implementation AdvertisingCacheManager

+ (AdvertisingCacheManager *)shareDataManager
{
    static AdvertisingCacheManager *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AdvertisingCacheManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

- (BOOL)shouldLoadAdImage:(NSString *)urlString
{
    BOOL shouldLoadAdImage = NO;
    NSString *strImgUrl = [NSString stringWithFormat:@"%@",urlString];
    if(strImgUrl==nil)
    {
        return shouldLoadAdImage;
    }
    if ([[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:strImgUrl]]) {
        shouldLoadAdImage = YES;
    }else {
        shouldLoadAdImage = NO;
    }
//    [self loadAdImageData:urlString];
    return shouldLoadAdImage;
}

- (void)loadAdImageData:(NSString *)urlString
{
    NSString *strImgUrl = [NSString stringWithFormat:@"%@",urlString];
    if (![[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:strImgUrl]])
    {
        
        SDWebImageManager *sdWebImageManager = [SDWebImageManager sharedManager];
        __weak __typeof(SDWebImageManager *)weakSDWebImageManager = sdWebImageManager;
        
        NSURL *urlAdImage = [NSURL URLWithString:urlString];
        if (![sdWebImageManager diskImageExistsForURL:urlAdImage]){
            [sdWebImageManager downloadImageWithURL:urlAdImage options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image && finished) {
                    //图片下载完成，将图片缓存到磁盘上
                        NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
                    UIAlertView *alers = [[UIAlertView alloc] initWithTitle:@"最新广告页下载完成" message:[NSString stringWithFormat:@"下载图片大小%0.2fkb，再次启动就会展示",((float)[imgData length]/1024.0)] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
                    [alers show];
                    [weakSDWebImageManager diskImageExistsForURL:urlAdImage completion:^(BOOL isInCache) {
                        NSData *imgData = UIImageJPEGRepresentation(image, 1.0);

                        UIAlertView *alers = [[UIAlertView alloc] initWithTitle:@"最新广告页缓存" message:[NSString stringWithFormat:@"下载图片大小%0.2fkb，再次启动就会展示",((float)[imgData length]/1024.0)] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
                        [alers show];
                    }];
                }
            }];
        }
    }
}


- (void)clearImageData:(NSString *)urlString
{
    SDWebImageManager *sdImageManager = [SDWebImageManager sharedManager];
    NSString *strCacheKey = [sdImageManager cacheKeyForURL:[NSURL URLWithString:urlString]];
    [[sdImageManager imageCache] removeImageForKey:strCacheKey fromDisk:YES];
}


- (UIImage *)getImageData:(NSString *)urlString
{
    SDWebImageManager *sdImageManager = [SDWebImageManager sharedManager];
    NSString *strCacheKey = [sdImageManager cacheKeyForURL:[NSURL URLWithString:urlString]];
    UIImage *adImage = [[sdImageManager imageCache] imageFromMemoryCacheForKey:strCacheKey];
    if (nil == adImage) {
        adImage = [[sdImageManager imageCache] imageFromDiskCacheForKey:strCacheKey];
    }
    return adImage;
}









//不用SDWebImageManager
//判断文件是否存在
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}


//下载新图片
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
        
    });
}

//删除旧图片
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

//根据图片名拼接文件路径
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}



@end
