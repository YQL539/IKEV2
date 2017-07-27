//
//  TestViewController.m
//  VPN
//
//  Created by apple on 2017/7/27.
//  Copyright © 2017年 不愿透露姓名的洪先生. All rights reserved.
//

#import "TestViewController.h"
#import <NetworkExtension/NetworkExtension.h>
#import "IkEV2Client.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 200, 200, 100);
    [self.view addSubview:btn];
    [btn setTitle:@"点击连接" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(connected) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(100, 400, 200, 80);
    [self.view addSubview:btn2];
    [btn2 setTitle:@"点击断开" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 addTarget:self action:@selector(disconnected) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVpnStateChange:) name:NEVPNStatusDidChangeNotification object:nil];
}

-(void)onVpnStateChange:(NSNotification *)Notification {
    NEVPNConnection *connect = Notification.object;
    NEVPNStatus state = connect.status;
    switch (state) {
        case NEVPNStatusInvalid:
            NSLog(@"无效连接");
            break;
        case NEVPNStatusDisconnected:
            NSLog(@"未连接");
            break;
        case NEVPNStatusConnecting:
            NSLog(@"正在连接");
            break;
        case NEVPNStatusConnected:
            NSLog(@"已连接");
            break;
        case NEVPNStatusDisconnecting:
            NSLog(@"断开连接");
            break;
        default:
            break;
    }
}
- (void)connected{
    [[IkEV2Client sharedMYSocketManager] startVPNConnect];
}

-(void)disconnected{
    [[IkEV2Client sharedMYSocketManager] endVPNConnect];
}
@end
