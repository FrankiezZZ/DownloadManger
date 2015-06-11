//
//  DownloadOpration.m
//  02-下载器
//
//  Created by 汤蓉 on 15/6/11.
//  Copyright (c) 2015年 zhm. All rights reserved.
//

#import "DownloadOpration.h"

@interface DownloadOpration ()<NSURLConnectionDataDelegate>

///  进度block
@property (copy, nonatomic) void(^progressBlock)(float);
///  结束后回调block
@property (copy, nonatomic) void(^finishedBlock)(NSString *, NSError *);

///  文件下载流
@property (strong, nonatomic) NSOutputStream *fileStream;
///  记录文件总长度
@property (assign, nonatomic) long long fileLength;
///  文件当前长度
@property (assign, nonatomic) long long currentFileLength;
///  当前下载连接
@property (strong, nonatomic) NSURLConnection *connection;
///  目标文件夹
@property (copy, nonatomic) NSString *targetPath;

///  记录下载进度
@property (assign, nonatomic) float progressPercent;

@end

@implementation DownloadOpration

+ (instancetype)downloadOprationWith:(NSURL *)url progress:(void (^)(float))progress finished:(void (^)(NSString *, NSError *))finished
{
    DownloadOpration *obj = [[self alloc] init];
    
    obj.progressBlock = progress;
    obj.finishedBlock = finished;
    obj.progressPercent = 0;
    
    return obj;
}

- (void)download:(NSURL *)url
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //检查服务器信息
        [self checkServerInfo:url];
        
        //检查本地文件信息
        [self checkLocalFileInfo];
        NSLog(@"current length: %lld",self.currentFileLength);
        if (self.currentFileLength == self.fileLength) {
            //一样大，文件已经下载完成
            NSLog(@"下载完成");
            //刷新UI
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.progressBlock(1);
            });
            return;
        }
        
        //断点续传
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
        
        // range头
        NSString *range = [NSString stringWithFormat:@"bytes=%lld-", self.currentFileLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        //建立连接，立即执行
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
        //打开runloop，
        [[NSRunLoop currentRunLoop] run];
    });
}

- (void)checkServerInfo:(NSURL *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"HEAD";
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    //得到响应
    //目标文件大小
    self.fileLength = response.expectedContentLength;
    //目标文件夹
    self.targetPath = [NSTemporaryDirectory() stringByAppendingPathComponent:response.suggestedFilename];
}

- (void)checkLocalFileInfo
{
    NSFileManager *manager = [NSFileManager defaultManager];
    self.currentFileLength = 0;
    //查询当前文件夹下文件是否存在，获得大小
    if ([manager fileExistsAtPath:self.targetPath]) {
        NSDictionary *attr = [manager attributesOfItemAtPath:self.targetPath error:NULL];
        self.currentFileLength = attr.fileSize;
    }
    
    if (self.fileLength < self.currentFileLength) {
        //直接删除文件
        [manager removeItemAtPath:self.targetPath error:NULL];
    }
}

//获得响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.fileStream = [[NSOutputStream alloc] initToFileAtPath:self.targetPath append:YES];
    [self.fileStream open];
}

//获取数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //    NSLog(@"did receive:%@",data);
    self.currentFileLength += data.length;
    self.progressPercent = (float)self.currentFileLength / self.fileLength;
    //NSLog(@"have downloaded: %f  %@", progressPercent, [NSThread currentThread]);
    //主线程刷新UI
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.progressBlock(self.progressPercent);
    });
    [self.fileStream write:data.bytes maxLength:data.length];
}

//断开连接
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"连接结束");
    [self.fileStream close];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.finishedBlock(self.targetPath, nil);
    });
}

//发生错误
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
    [self.fileStream close];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.finishedBlock(nil, error);
    });
}


@end









