//
//  ViewController.m
//  AdvertisingPageTest
//
//  Created by 余晔 on 2017/7/3.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import "ViewController.h"
#import "SDWebImageManager.h"
#import "AdvertisingCacheManager.h"
#import "ZJStoreDefaults.h"

@interface ViewController ()
@property (nonatomic,strong)UIImageView *imageView;
@property(nonatomic,assign)BOOL shouldLoadAd;

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    _shouldLoadAd = YES;
    NSString *strImgUrl = [ZJStoreDefaults getObjectForKey:@"img3"];
//    if(strImgUrl==nil)
//    {
//        strImgUrl = @"http://pic25.nipic.com/20121126/668573_135245356150_2.jpg";
//    }
//    NSString *strImgUrl = @"http://www.wyzu.cn/uploadfile/2012/0831/20120831120146955.jpg";
//    NSString *strImgUrl = @"http://pic25.nipic.com/20121126/668573_135245356150_2.jpg";
    
    _imageView = [[UIImageView alloc] init];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.userInteractionEnabled = YES;
    _imageView.clipsToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:_imageView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
    NSString *strimg = @"http://pic25.nipic.com/20121126/668573_135245356150_2.jpg";
    [ZJStoreDefaults setObject:@"http://pic25.nipic.com/20121126/668573_135245356150_2.jpg" forKey:@"img3"];
    
    if ([[AdvertisingCacheManager shareDataManager] shouldLoadAdImage:strImgUrl] && _shouldLoadAd)
    {
        _shouldLoadAd = NO;
    
        UIImage *adimage = [[AdvertisingCacheManager shareDataManager] getImageData:strImgUrl];
        
        [_imageView setImage:adimage];
        if(![strImgUrl isEqualToString:strimg])
        {
            [[AdvertisingCacheManager shareDataManager] clearImageData:strImgUrl];
        }
    }

    if (![[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:strimg]]) {
        [[AdvertisingCacheManager shareDataManager] loadAdImageData:strimg];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
