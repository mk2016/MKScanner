//
//  MKOverView.h
//  Taoqicar
//
//  Created by xiaomk on 2019/6/6.
//  Copyright © 2019 taoqicar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKQuadrilateral.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKOverView : UIView
@property (assign, nonatomic) BOOL showCorner;  /*!< 是否只显示角标 default:NO */
@property (assign, nonatomic) BOOL dashed;      /*!< 是否虚线 default:NO showCorner=YES 时 无效 */
@property (assign, nonatomic) BOOL hollowOut;   /*!< 是否镂空 default:NO */
@property (strong, nonatomic) UIColor *borderColor;   /*!< border color */

- (void)refreshWith:(MKQuadrilateral *)quadrilateral;
- (void)remove;
@end

NS_ASSUME_NONNULL_END
