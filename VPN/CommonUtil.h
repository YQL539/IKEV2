//  CommonUtil.h
//  xiaotu
//
//  Created by relech on 15/6/17.
//  Copyright (c) 2015年 relech. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/utsname.h>
@interface CommonUtil : NSObject
/**
 *  清除搜索框的背景色
 *
 *  @param pSearchBar 搜索框
 */
+(void) ClearSearchBarBackGround:(UISearchBar*) pSearchBar;
/**
 *  设置搜索框背景色
 *
 *  @param pSearchBar 搜索框
 *  @param pColor     颜色
 */
+(void) SetSearchBarBackGround:(UISearchBar*) pSearchBar color:(UIColor*)pColor;
/**
 *  获取项目沙盒目录
 *
 *  @return 沙盒目录+zuozuo
 */
+(NSString*) GetProjDir;
/**
 *  创建目录
 *
 *  @param pFold 需要创建的目录
 *
 *  @return 创建返回的结果
 */
+(BOOL) CreatePath:(NSString*)pFold;
/**
 *  删除目录
 *
 *  @param pFold 需要删除的目录
 *
 *  @return 结果
 */
+(BOOL) DeletePath:(NSString*)pFold;
/**
 *  查看文件是否存在
 *
 *  @param pFile 文件路径
 *
 *  @return 结果
 */
+(BOOL) FileExist:(NSString*)pFile;
/**
 *  从路径中获取文件名
 *
 *  @param pFile 包含文件名的路径
 *
 *  @return 文件名
 */
+(NSString*) GetFileName:(NSString*)pFile;
/**
 *  获取文件路径
 *
 *  @param pFile 包含路径的字符串
 *
 *  @return 文件路径
 */

+(NSString*) GetFilePath:(NSString*)pFile;
/**
 *  根据十六进制字符串获得颜色
 *
 *  @param pColor 十六进制字符串
 *
 *  @return 颜色
 */
+ (UIColor *)GetColor:(NSString *)pColor;
/**
 *  根据十六进制字符串获得颜色
 *
 *  @param pColor 十六进制字符串
 *  @param dAlpha 透明度
 *
 *  @return 颜色
 */
+ (UIColor *)GetColor:(NSString *)pColor alpha:(CGFloat) dAlpha;
/**
 *  根据毫秒获取时间字符串
 *
 *  @param iDenty 毫秒
 *
 *  @return 时间字符串
 */
+ (NSString *)GetCurrentTimeDate:(long)iDenty;
+ (NSString *)GetCurrentTimeDate2:(long)iDenty;
/**
 * 根据时间毫秒数转换成YYYY-MM-DD YYYY:MM:DD
 */
+ (NSString *)MillsecToTime:(long)iMillSec;
+ (NSString *)MillsecToTime2:(long)iMillSec;
+ (NSString *)MillsecToTime3:(long)iMillSec;
+ (NSString *)MillsecToTime4:(long)iMillSec;
/**
 *  根据毫秒获取当月总天数
 *
 *  @param iTime 毫秒
 *
 *  @return 天数
 */
+(NSInteger)GetAllDaysNumOfMonthWith:(long)iTime;
/**
 *  判断是否有网
 *
 *  @return 结果
 */
+ (BOOL)ConnectedToNetwork;

/**
 *  查看文件是否存在
 *
 *  @param pFile 文件路径
 *
 *  @return 结果
 */
+(BOOL) IsExistFile:(NSString*)pFile;
/**
 *  删除文件
 *
 *  @param pFile 文件路径
 *
 *  @return 结果
 */
+(BOOL) RemoveFile:(NSString*)pFile;
/**
 *  判断是否是手机号码
 *
 *  @param pstrMobile 需要检测的字符串
 *
 *  @return 结果
 */
+ (BOOL) IsValiddateMobile:(NSString*)pstrMobile;
/**
 *  判断是不是邮箱
 *
 *  @param pEmail 需要检测的字符串
 *
 *  @return 结果
 */
+ (BOOL) IsValidateEmail:(NSString *)pEmail;
/**
 *  获取拼音首字母
 *
 *  @param pString 汉字字符串
 *
 *  @return 大写拼音首字母
 */
+(NSString *)FirstCharactor:(NSString *)pString;

/**
 *   将时间字符串转化成毫秒
 *
 *  @param pstrTime 时间字符串
 *
 *  @return 转化成毫秒的字符串
 */
+(long) CurTimeMilSec:(NSString*)pstrTime;
/**
 *  获取当前时间毫秒
 *
 *  @return 当前时间毫秒
 */
+(long) CurTimeMilSec;


/**
 *  获取格式化后的时间(今天|昨天|前天)
 *
 *  @param iTime 需要转化的时间
 *
 *  @return 格式化后的时间
 */
+(NSString *)GetFormatTime:(long)iTime;
/**
 *  将图片裁剪成给定尺寸
 *
 *  @param image 原始图片
 *  @param size  自定义尺寸
 *  @return 裁剪后的图片
 */
+(UIImage*) customImageSize:(UIImage *)image scaleToSize:(CGSize)size;
/**
 * 获取200*200图片
 */

+(UIImage *)getMiniImage:(UIImage*)image;
/**
 获取from 到 to 之间的随机数
 */
+(int)GettRandomNumber:(int)iFrom to:(int)iTo;
/**
 获取View上的截图
 */
+ (UIImage *) screenImage:(UIView *)view;
/**
 气泡融合
 */
+ (void) MastViewByImage:(UIView *)maskedView withMaskImage:(UIView *)maskImageView;
/**
 //将UIView部分截取成UIimage图片格式
 */
+(UIImage *)ClipToImageFromUIView:(UIView *)BigView CGRect:(CGRect)CGRect;

/**
*  高斯模糊图片
*/
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
/**
 *  高斯模糊View
 */
+(void)addCoreBlurView:(UIView *)pView;
/**
 //获取当前时间
 */
+(NSString *)GetCurrentTime;
/**
 *  判断两个时间戳是否是同一天
 *
 */

+ (BOOL)isSameDay:(long)iTime1 Time2:(long)iTime2;
/**
 *  Base64加密
 *
 */
+(NSString *)base64EncodeWithString:(NSString *)pstrString;
/**
 *  Base64解密
 *
 */
+(NSString *)base64DecodeWithString:(NSString *)pstrBase64String;
/**
 *  手机model转手机型号
 *
 */
+ (NSString *)GetIphoneTypeFromModel:(NSString *)iPhoneModel;
/**
 *  打开系统wifi
 *
 */
+(void)openWIFI;

@end
