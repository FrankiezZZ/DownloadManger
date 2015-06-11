//
//  ViewController.m
//  02-下载器
//
//  Created by 汤蓉 on 15/6/10.
//  Copyright (c) 2015年 zhm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSOutputStream *fileStream;

///  记录文件总长度
@property (assign, nonatomic) long long fileLength;
///  文件当前长度
@property (assign, nonatomic) long long currentFileLength;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/html.mp4"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //建立连接，立即执行
        [NSURLConnection connectionWithRequest:request delegate:self];
        //打开runloop，
        [[NSRunLoop currentRunLoop] run];
    });
}

//获得响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.fileLength = response.expectedContentLength;
    //当前文件长度置零
    self.currentFileLength = 0;
    self.fileStream = [[NSOutputStream alloc] initToFileAtPath:@"/Users/tang-Fiona/Desktop/html.mp4" append:YES];
    [self.fileStream open];
}

//获取数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
//    NSLog(@"did receive:%@",data);
    self.currentFileLength += data.length;
    float progressPercent = (float)self.currentFileLength / self.fileLength;
    NSLog(@"have downloaded: %f  %@", progressPercent, [NSThread currentThread]);
    [self.fileStream write:data.bytes maxLength:data.length];
}

//断开连接
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"连接结束");
    [self.fileStream close];
}

//发生错误
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
    [self.fileStream close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end








