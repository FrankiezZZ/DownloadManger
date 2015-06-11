//
//  ViewController.m
//  02-下载器
//
//  Created by 汤蓉 on 15/6/10.
//  Copyright (c) 2015年 zhm. All rights reserved.
//

#import "ViewController.h"
#import "ProgressButton.h"
#import "DownloadOpration.h"
#import "DownloadManager.h"

@interface ViewController ()<NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet ProgressButton *progressBtn;

@end

@implementation ViewController
//暂停操作
- (IBAction)pause {
#warning TODO
    //[self.connection cancel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/html.mp4"];
    
    [[DownloadManager sharedDownloadManager] downloadManagerWith:url progress:^(float progress) {
        self.progressBtn.progress = progress;
    } finished:^(NSString *targetPath, NSError *error) {
        NSLog(@"%@  %@  %@", targetPath, error, [NSThread currentThread]);
    }];
}

@end








