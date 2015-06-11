//
//  DownloadManager.h
//  02-下载器
//
//  Created by 汤蓉 on 15/6/11.
//  Copyright (c) 2015年 zhm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject

+ (instancetype)sharedDownloadManager;

- (void)downloadManagerWith:(NSURL *)url progress:(void(^)(float progress))progress finished:(void(^)(NSString *targetPath, NSError *error))finished;

@end
