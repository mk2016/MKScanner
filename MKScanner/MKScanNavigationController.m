//
//  MKScanNavigationController.m
//  MKScanner
//
//  Created by xiaomk on 2019/5/25.
//  Copyright © 2019 mk. All rights reserved.
//

#import "MKScanNavigationController.h"
#import "MKScan_VC.h"

@interface MKScanNavigationController ()
@property (nonatomic, strong) UIView *blackFlashView;
@end

@implementation MKScanNavigationController


+ (MKScanNavigationController *)createScanNavigationController{
    MKScan_VC *vc = [[MKScan_VC alloc] init];
    MKScanNavigationController *nav = [[MKScanNavigationController alloc] initWithRootViewController:vc];
    return nav;
}

//- (instancetype)init{
//    if (self = [super init]) {
//        self.navigationBar.tintColor = UIColor.blackColor;
//        self.navigationBar.translucent = false;
//        [self.view addSubview:self.blackFlashView];
//    }
//    return self;
//}
//
//- (UIView *)blackFlashView{
//    if (!_blackFlashView) {
//        _blackFlashView = [[UIView alloc] init];
//        _blackFlashView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//        _blackFlashView.hidden = YES;
//    }
//    return _blackFlashView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
