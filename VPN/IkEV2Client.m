//
//  IkEV2Client.m
//  VPN
//
//  Created by apple on 2017/7/27.
//  Copyright © 2017年 不愿透露姓名的洪先生. All rights reserved.
//

#import "IkEV2Client.h"
#import <NetworkExtension/NetworkExtension.h>
@interface IkEV2Client ()
@property (nonatomic, strong) NEVPNManager *manage;

@end

@implementation IkEV2Client

+ (IkEV2Client *)sharedMYSocketManager
{
    static dispatch_once_t onceToken;
    static IkEV2Client *instance;
    dispatch_once(&onceToken, ^{
        instance = [[IkEV2Client alloc] init];
    });
    return instance;
}

-(instancetype)init{
    if (self == [super init]) {
         self.manage = [NEVPNManager sharedManager];
    }
    return self;
}

-(void)endVPNConnect
{
    [self prepareVPNConnectWithCompleteHandle:nil];
}
-(void)startVPNConnect
{
    [self prepareVPNConnectWithCompleteHandle:^(NSError *error) {
        if(error) {
            NSLog(@"Save error1111: %@", error);
        }
        else {
            NSLog(@"Saved!");
            NSError *error = nil;
            //开始连接
            [self.manage.connection startVPNTunnelAndReturnError:&error];
            if(error) {
                NSLog(@"Start error2222: %@", error.localizedDescription);
                [self startVPNConnect];
            }
            else
            {
                NSLog(@"Connection established!");
            }
        }
    }];
}

-(void)prepareVPNConnectWithCompleteHandle:(void(^)(NSError *error))complete{
    [self.manage loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
        NSError *errors = error;
        if (errors) {
            NSLog(@"错误：%@",errors);
        }
        else{
            NEVPNProtocolIKEv2 *p = [[NEVPNProtocolIKEv2 alloc] init];
            //用户名
            p.username = userName;
            //服务器地址
            p.serverAddress = serviceIP;
            //密码
            [self createKeychainValue:passWord forIdentifier:@"VPN_PASSWORD"];
            p.passwordReference =  [self searchKeychainCopyMatching:@"VPN_PASSWORD"];
            //共享秘钥  可以和密码同一个.
            [self createKeychainValue:PSKPassword forIdentifier:@"PSK"];
            p.sharedSecretReference = [self searchKeychainCopyMatching:@"PSK"];
            p.localIdentifier = @"";
            p.remoteIdentifier = serviceIP;
            p.authenticationMethod = NEVPNIKEAuthenticationMethodNone;
            p.useExtendedAuthentication = YES;
            p.disconnectOnSleep = YES;
            self.manage.onDemandEnabled = NO;
            [self.manage setProtocolConfiguration:p];
            self.manage.localizedDescription = @"WoVPNForStore";
            self.manage.enabled = true;
            [self.manage saveToPreferencesWithCompletionHandler:complete];
        }
    }];
}


- (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [searchDictionary setObject:@YES forKey:(__bridge id)kSecReturnPersistentRef];
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &result);
    return (__bridge_transfer NSData *)result;
}

- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    // creat a new item
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    //OSStatus 就是一个返回状态的code 不同的类返回的结果不同
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dictionary);
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    //   keychain item creat
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    //   extern CFTypeRef kSecClassGenericPassword  一般密码
    //   extern CFTypeRef kSecClassInternetPassword 网络密码
    //   extern CFTypeRef kSecClassCertificate 证书
    //   extern CFTypeRef kSecClassKey 秘钥
    //   extern CFTypeRef kSecClassIdentity 带秘钥的证书
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    //ksecClass 主键
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:serviceIP forKey:(__bridge id)kSecAttrService];
    return searchDictionary;
}

-(BOOL)isVPNConnectedService
{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://ipof.in/txt"];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    if ([ip isEqualToString:serviceIP]) {
        return YES;
    }else{
        return NO;
    }
}

@end
