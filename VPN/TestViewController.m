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
@property (nonatomic,strong) UILabel *showLabel;
@property (nonatomic,strong) UILabel *ipLabel;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 40)];
    [self.view addSubview:_showLabel];
    _showLabel.textAlignment = NSTextAlignmentCenter;
    _showLabel.textColor = [UIColor blackColor];
    _showLabel.backgroundColor = [UIColor lightGrayColor];
    
    _ipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_showLabel.frame)+20, self.view.frame.size.width, 40)];
    [self.view addSubview:_ipLabel];
    _ipLabel.textAlignment = NSTextAlignmentCenter;
    _ipLabel.textColor = [UIColor blackColor];
    _ipLabel.backgroundColor = [UIColor lightGrayColor];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(40, CGRectGetMaxY(_ipLabel.frame) + 20, 200, 100);
    [self.view addSubview:btn];
    [btn setTitle:@"点击连接" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(connected) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(40, CGRectGetMaxY(btn.frame) + 20, 200, 80);
    [self.view addSubview:btn2];
    [btn2 setTitle:@"点击断开" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 addTarget:self action:@selector(disconnected) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVpnStateChange:) name:NEVPNStatusDidChangeNotification object:nil];
    [self checkIp];
    
}

-(void)onVpnStateChange:(NSNotification *)Notification {
    NEVPNConnection *connect = Notification.object;
    NEVPNStatus state = connect.status;
    NSString *show = nil;
    switch (state) {
        case NEVPNStatusInvalid:
            NSLog(@"无效连接");
            show = @"无效连接";
            break;
        case NEVPNStatusDisconnected:
            NSLog(@"未连接");
            show = @"未连接";
            break;
        case NEVPNStatusConnecting:
            NSLog(@"正在连接");
            show = @"正在连接";
            break;
        case NEVPNStatusConnected:
            NSLog(@"已连接");
            show = @"已连接";
            break;
        case NEVPNStatusDisconnecting:
            NSLog(@"断开连接");
            show = @"断开连接";
            break;
        default:
            break;
    }
    BOOL isOK = [self isVPNConnected];
    NSString *VPNStatus = @"";
    if (isOK) {
        VPNStatus = @"VPN在连接";
    }else{
        VPNStatus = @"VPN没有连接";
    }
    _showLabel.text = [VPNStatus stringByAppendingString:show];
}

- (void)connected{
    [[IkEV2Client sharedMYSocketManager] startVPNConnect];
}

-(void)disconnected{
    [[IkEV2Client sharedMYSocketManager] endVPNConnect];
}

-(void)checkIp{
    
//    BOOL isOK = [self isVPNConnected];
//    NSString *connect = @"";
//    if (isOK) {
//        connect = @"VPN在连接";
//    }else{
//        connect = @"VPN没有连接";
//    }
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://ipof.in/txt"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    
    if ([ip isEqualToString:@"119.28.44.232"]) {
        _ipLabel.text = [NSString stringWithFormat:@"=%@=是我们的服务器IP",ip];
        return;
    }else{
        _ipLabel.text = [NSString stringWithFormat:@"=%@====非我们自己服务器IP",ip];
    }

}

- (void)startMonitoringVPNStatusDidChange:(NEVPNStatus)status
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NEVPNStatusDidChangeNotification
                                                      object:[NEVPNManager sharedManager].connection
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      NSLog(@"startMonitoringVPNStatusDidChange");;
                                                  }];
}

- (BOOL)isVPNConnected
{
    UIApplication *app = [UIApplication sharedApplication];
    UIView *statusView = [app valueForKey:@"statusBar"];
    NSArray *subViews = [[statusView valueForKey:@"foregroundView"] subviews];
    Class StatusBarIndicatorItemViewClass = NSClassFromString(@"UIStatusBarIndicatorItemView");
    for (UIView *subView in subViews)
    {
        Class SubStatusBarIndicatorItemViewClass = [subView class];
        if ([SubStatusBarIndicatorItemViewClass isSubclassOfClass:StatusBarIndicatorItemViewClass])
        {
            NSString *desc = [subView description];
            BOOL isContainedVPN = [desc containsString:@"VPN"];
            if (isContainedVPN == YES)
            {
                return isContainedVPN;
            }
        }
    }
    return NO;
}

@end
