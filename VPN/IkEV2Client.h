//
//  IkEV2Client.h
//  VPN
//
//  Created by apple on 2017/7/27.
//  Copyright © 2017年 不愿透露姓名的洪先生. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IkEV2Client : NSObject

+ (IkEV2Client *)sharedMYSocketManager;
-(void)startVPNConnect;
-(void)endVPNConnect;

@end
