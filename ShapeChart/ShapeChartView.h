//
//  ShapeChartView.h
//  ShapeChart
//
//  Created by dongdf on 14-4-18.
//  Copyright (c) 2014年 dongdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShapeChartData;
@interface ShapeChartView : UIView

@property (nonatomic, retain) ShapeChartData *data;

/**
 *  下载完图片后调用显示文字
 */
- (void)shouldShowText;

/**
 *  下载完图片后调用显示连线及坐标轴上的点
 *
 *  @param animated 动画
 */
- (void)showLineAnimated:(BOOL)animated;

@end




@interface ShapeChartData : NSObject

/**
 *  源数据， 传入dic， 解析数据，然后赋值给各个属性
 */
@property (nonatomic, retain) NSDictionary *resourceData;

/**
 *  最低报价， 范围 0~1
 */
@property (nonatomic, assign) float minPricePercent;
/**
 *  最高报价， 范围 0~1
 */
@property (nonatomic, assign) float maxPricePercent;
/**
 *  参考成交价， 范围0~1
 */
@property (nonatomic, assign) float referencePricePercent;
/**
 *  厂商指导价， 范围0~1
 */
@property (nonatomic, assign) float guidePricePercent;
/**
 *  上方标题价格， NSString 必须三个元素
 */
@property (nonatomic, retain) NSArray *topDescriptions;
/**
 *  下方标题价格， NSString 必须三个元素
 */
@property (nonatomic, retain) NSArray *bottomDescriptions;
/**
 *  参考成交价
 */
@property (nonatomic, copy) NSString *referencePrice;
/**
 *  背景图片
 */
@property (nonatomic, retain) UIImage *image;

@end