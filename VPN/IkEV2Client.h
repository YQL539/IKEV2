//
//  IkEV2Client.h
//  VPN
//
//  Created by apple on 2017/7/27.
//  Copyright © 2017年 不愿透露姓名的洪先生. All rights reserved.
//

#import <Foundation/Foundation.h>
//服务器地址
static NSString * const serviceIP = @"119.28.44.232";
//用户名
static NSString * const userName = @"a";
//用户密码
static NSString * const passWord = @"666666";
//PSKPassword
static NSString * const PSKPassword = @"888888";

@interface IkEV2Client : NSObject

+ (IkEV2Client *)sharedMYSocketManager;
//开始连接
-(void)startVPNConnect;
//连接断开
-(void)endVPNConnect;
//是否连接服务器
-(BOOL)isVPNConnectedService;

@end
