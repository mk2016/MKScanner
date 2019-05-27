//
//  MKConst.h
//  MKScanner
//
//  Created by xiaomk on 2019/5/26.
//  Copyright © 2019 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** screen */
#define MK_SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define MK_SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define MK_SCREEN_SIZE      [UIScreen mainScreen].bounds.size
#define MK_SCREEN_BOUNDS    [UIScreen mainScreen].bounds
#define MK_SCREEN_CENTER    CGPointMake(MK_SCREEN_WIDTH/2, MK_SCREEN_HEIGHT/2);

/** device */
#define MK_IS_IPHONE        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define MK_IS_PAD           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define MK_IS_IPHONE_X_XS   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define MK_IS_IPHONE_XSMAX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define MK_IS_IPHONE_XR     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define MK_IS_IPHONE_XX     MK_IS_IPHONE_X_XS || MK_IS_IPHONE_XSMAX || MK_IS_IPHONE_XR

#define MK_IS_IPHONE_5      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
CGSizeEqualToSize(CGSizeMake(640, 1136),  [[UIScreen mainScreen] currentMode].size) : NO)
#define MK_IS_IPHONE_6      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
CGSizeEqualToSize(CGSizeMake(750, 1334),  [[UIScreen mainScreen] currentMode].size) : NO)
#define MK_IS_IPHONE_6Plus  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
CGSizeEqualToSize(CGSizeMeke(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define MK_SCREEN_STATUSBAR_HEIGHT      (MK_IS_IPHONE_XX ? 44 : 20)
#define MK_SCREEN_IPHONEX_IGNORE_HEIGHT (MK_IS_IPHONE_XX ? 24+34 : 0)
#define MK_SCREEN_IPHONEX_NAVGATION     (MK_IS_IPHONE_XX ? 88 : 64)
#define MK_SCREEN_IPHONEX_TOP           (MK_IS_IPHONE_XX ? 44 : 0)
#define MK_SCREEN_IPHONEX_BOTTOM        (MK_IS_IPHONE_XX ? 34 : 0)
#define MK_SCREEN_SAFE_HEIGHT           (MK_SCREEN_HEIGHT - MK_SCREEN_IPHONEX_TOP - MK_SCREEN_IPHONEX_BOTTOM)
#define MK_SCREEN_MAIN_HEIGHT           (MK_SCREEN_HEIGHT - MK_SCREEN_IPHONEX_NAVGATION - MK_SCREEN_IPHONEX_BOTTOM)
//#define MK_SCREEN_SAFE_FRAME            CGRectMake(0, MK_SCREEN_IPHONEX_NAVGATION, MK_SCREEN_WIDTH, MK_SCREEN_MAIN_HEIGHT)

#define MK_ONE_PIXEL_HEIGHT             (1.f/[UIScreen mainScreen].scale)
#define IPHONEX_HEAD_MARGIN             (MK_IS_IPHONE_XX ? 24 : 0)

/** block */
#define MK_BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };
typedef void (^MKBlock)(id result);
typedef void (^MKBoolBlock)(BOOL bRet);
typedef void (^MKVoidBlock)(void);
typedef void (^MKIntegerBlock)(NSInteger index);
typedef void (^MKArrayBlock)(NSArray *array);

#define kMK_FOCAL_SCALE         1.0
#define kMK_RESOLUTION_WIDTH    1280.0
#define kMK_RESOLUTION_HEIGHT   720.0
