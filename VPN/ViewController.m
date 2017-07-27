//
//  ViewController.m
//  VPN
//
//  Created by Godlike on 2017/6/2.
//  Copyright © 2017年 不愿透露姓名的洪先生. All rights reserved.
//

#import "ViewController.h"
#import <NetworkExtension/NetworkExtension.h>

@interface ViewController ()
@property (nonatomic, strong) NEVPNManager *manage;
@end


#pragma mark - Demo

/**
 *
 *      如果你的
 *      服务器地址   用户名   密码  是对的话!
 *
 *      这个Demo 是好使的  如果这几个没有填是肯定不好使的,,,,
 *
 *      感谢你看这个代码 辛苦了 !!!  😁  
 *
 */

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *directory = NSHomeDirectory();
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General&path=ManagedConfigurationList"]];
    //证书地址WYCA
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://123.207.70.64/ca.cert.pem"]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://123.207.70.64/2.mobileconfig"]];
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
            
/***********************************************************************************************************************************/
            //导入p12证书
//            NSData *cerData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"client.cert" ofType:@"p12"]];
//            p.identityData = cerData;
//            p.identityReference = cerData;
//            //导入p12密码
//            p.identityDataPassword = @"666";
//            p.serverCertificateCommonName = @"WY VPN Profile";
//            p.serverCertificateIssuerCommonName = @"WY IKEv2 VPN";
//            p.certificateType=NEVPNIKEv2CertificateTypeECDSA256;
//            p.disableMOBIKE = YES;
//            p.deadPeerDetectionRate = NEVPNIKEv2DeadPeerDetectionRateMedium;
            
/***********************************************************************************************************************************/
            //NEVPNIKEAuthenticationMethodCertificate===useExtendedAuthentication设为yes==需要Safari安装CA证书连接
            //NEVPNIKEAuthenticationMethodSharedSecret
            //NEVPNIKEAuthenticationMethodNone==useExtendedAuthentication设为YES==不用配置证书直接连接
            p.authenticationMethod = NEVPNIKEAuthenticationMethodNone;
            p.useExtendedAuthentication = YES;
            p.disconnectOnSleep = YES;
            self.manage.onDemandEnabled = NO;
            
            [self.manage setProtocolConfiguration:p];
            self.manage.localizedDescription = @"p12测试";
            
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
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVpnStateChange:) name:NEVPNStatusDidChangeNotification object:nil];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 100)];
    [self.view addSubview:btn];
    [btn setTitle:@"点击连接" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(connected) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 120, 40)];
    [self.view addSubview:btn2];
    [btn2 setTitle:@"点击断开" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 addTarget:self action:@selector(disconnected) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)onVpnStateChange:(NSNotification *)Notification {
    
    NEVPNStatus state = self.manage.connection.status;
 
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
    NSError *error = nil;
    [self.manage.connection startVPNTunnelAndReturnError:&error];
    if(error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"连接错误" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        NSLog(@"Start error: %@", error.localizedDescription);
    }
    else
    {
        NSLog(@"Connection established!");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Connection established!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)disconnected{
    [self.manage.connection stopVPNTunnel];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"VPN连接断开" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
