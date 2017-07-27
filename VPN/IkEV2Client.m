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
        [self prepareVPNConnect];
    }
    return self;
}

-(void)prepareVPNConnect
{
    self.manage = [NEVPNManager sharedManager];
    [self.manage loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
        NSError *errors = error;
        if (errors) {
            NSLog(@"%@",errors);
        }
        else{
            NEVPNProtocolIKEv2 *p = [[NEVPNProtocolIKEv2 alloc] init];
            //用户名
            p.username = @"a";
            //服务器地址
            p.serverAddress = @"119.28.44.232";
            //密码
            [self createKeychainValue:@"666666" forIdentifier:@"VPN_PASSWORD"];
            p.passwordReference =  [self searchKeychainCopyMatching:@"VPN_PASSWORD"];
            //共享秘钥    可以和密码同一个.
            [self createKeychainValue:@"888888" forIdentifier:@"PSK"];
            p.sharedSecretReference = [self searchKeychainCopyMatching:@"PSK"];
            p.localIdentifier = @"";
            p.remoteIdentifier = @"119.28.44.232";
            //NEVPNIKEAuthenticationMethodCertificate===useExtendedAuthentication设为yes==需要Safari安装CA证书连接
            //NEVPNIKEAuthenticationMethodSharedSecret
            //NEVPNIKEAuthenticationMethodNone==useExtendedAuthentication设为YES==不用配置证书直接连接=EAP必须打开
            p.authenticationMethod = NEVPNIKEAuthenticationMethodNone;
            p.useExtendedAuthentication = YES;
            p.disconnectOnSleep = YES;
            self.manage.onDemandEnabled = NO;
            [self.manage setProtocolConfiguration:p];
            self.manage.localizedDescription = @"client测试";
            
            self.manage.enabled = true;
            
            [self.manage saveToPreferencesWithCompletionHandler:^(NSError *error) {
                if(error) {
                    NSLog(@"Save error: %@", error);
                }
                else {
                    NSLog(@"Saved!");
                }
            }];
        }
    }];

}
-(void)startVPNConnect
{
    NSError *error = nil;
    [self.manage.connection startVPNTunnelAndReturnError:&error];
    if(error) {
        NSLog(@"Start error: %@", error.localizedDescription);
    }
    else
    {
        NSLog(@"Connection established!");
    }
}

-(void)endVPNConnect
{
    [self.manage.connection stopVPNTunnel];
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

//服务器地址
static NSString * const serviceName = @"119.28.44.232";

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
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    return searchDictionary;
}

@end
