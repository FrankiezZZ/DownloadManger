//
//  DownloadManager.m
//  02-下载器
//
//  Created by 汤蓉 on 15/6/11.
//  Copyright (c) 2015年 zhm. All rights reserved.
//

#import "DownloadManager.h"
#include "DownloadOpration.h"

@implementation DownloadManager

+ (instancetype)sharedDownloadManager
{
    static id obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}

- (void)downloadManagerWith:(NSURL *)url progress:(void (^)(float))progress finished:(void (^)(NSString *, NSError *))finished
{
    DownloadOpration *downloader = [DownloadOpration downloadOprationWith:url progress:progress finished:finished];
    
    [downloader download:url];
}

@end
