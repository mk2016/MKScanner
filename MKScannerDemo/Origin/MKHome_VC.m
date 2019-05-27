//
//  MKHome_VC.m
//  MKScanner
//
//  Created by xiaomk on 2019/5/25.
//  Copyright © 2019 mk. All rights reserved.
//

#import "MKHome_VC.h"
#import "MKScan_VC.h"
#import "MKScanNavigationController.h"
#import "MKconst.h"

@interface MKHome_VC ()

@end

@implementation MKHome_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MKSCANNER";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 300, MK_SCREEN_WIDTH-40, 50);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"scan" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonAction{

    
    MKScanNavigationController *nav = [MKScanNavigationController createScanNavigationController];
    [self presentViewController:nav animated:YES completion:nil];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}


@end
