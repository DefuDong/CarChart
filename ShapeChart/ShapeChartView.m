//
//  ShapeChartView.m
//  ShapeChart
//
//  Created by dongdf on 14-4-18.
//  Copyright (c) 2014年 dongdf. All rights reserved.
//

#import "ShapeChartView.h"

#define kLineWidth 1
static NSString *topTitles[] = {@"风险", @"适宜", @"偏贵"};
static NSString *bottomTitles[] = {@"最低报价", @"厂商指导价", @"最高报价"};

@interface ShapeChartView ()
{
    float width;
    float height;
    
    CGRect bottomRects[3];
    CGRect refRect;
    
    //\//\//
    BOOL _needDrawPoints;
    
    CAShapeLayer *_refLineLayer;
    CAShapeLayer *_linesLayer;
}

@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, retain) UIColor *axisColor;
@property (nonatomic, retain) UIColor *pointColor;
@property (nonatomic, retain) UIColor *refPointColor;

@property (nonatomic, retain) UIFont *topTextFont;
@property (nonatomic, retain) UIFont *bottomTextFont;

@end

@implementation ShapeChartView
#pragma mark - setters
- (void)setData:(ShapeChartData *)data {
    if (_data != data) {
        [_data release];
        _data = [data retain];
        [self setNeedsDisplay];
        [self setLayersPath];
    }
}


#pragma mark -
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self perset];
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self perset];
        [self initialize];
    }
    return self;
}

- (void)perset {
    self.backgroundColor = [UIColor whiteColor];
    
    self.lineColor = [UIColor lightGrayColor];
    self.axisColor = [UIColor blueColor];
    self.pointColor = [UIColor blueColor];
    self.refPointColor = [UIColor redColor];
    
    self.topTextFont = [UIFont systemFontOfSize:12];
    self.bottomTextFont = [UIFont systemFontOfSize:11];
    
    _needDrawPoints = NO;
}

- (void)initialize {
    width = self.frame.size.width;
    height = self.frame.size.height;
    
    bottomRects[0] = (CGRect){0,height-32.5,105,32};
    bottomRects[1] = (CGRect){107.5,height-32.5,105,32};
    bottomRects[2] = (CGRect){215,height-32.5,105,32};
    refRect = CGRectInset(self.bounds, width/2.9, height/2.7);
    
    _linesLayer = [CAShapeLayer layer];
    _linesLayer.frame = self.bounds;
    _linesLayer.strokeColor = self.pointColor.CGColor;
    _linesLayer.fillColor = [UIColor clearColor].CGColor;
    _linesLayer.lineWidth = 1;
    _linesLayer.strokeEnd = 0;
    [self.layer addSublayer:_linesLayer];
    
    _refLineLayer = [CAShapeLayer layer];
    _refLineLayer.frame = self.bounds;
    _refLineLayer.strokeColor = self.refPointColor.CGColor;
    _refLineLayer.fillColor = [UIColor clearColor].CGColor;
    _refLineLayer.lineWidth = 1;
    _refLineLayer.strokeEnd = 0;
    [self.layer addSublayer:_refLineLayer];
}

- (void)setLayersPath {
    float minX          = width * self.data.minPricePercent;
    float maxX          = width * self.data.maxPricePercent;
    float referenceX    = width * self.data.referencePricePercent;
    float guideX        = width * self.data.guidePricePercent;

    CGMutablePathRef linesPath = CGPathCreateMutable();
    CGPathMoveToPoint(linesPath, NULL, CGRectGetMidX(bottomRects[0]), CGRectGetMinY(bottomRects[0]));
    CGPathAddLineToPoint(linesPath, NULL, CGRectGetMidX(bottomRects[0]), 142);
    CGPathAddLineToPoint(linesPath, NULL, minX, 142);
    CGPathAddLineToPoint(linesPath, NULL, minX, 134+3);
    CGPathMoveToPoint(linesPath, NULL, CGRectGetMidX(bottomRects[1]), CGRectGetMinY(bottomRects[1]));
    CGPathAddLineToPoint(linesPath, NULL, CGRectGetMidX(bottomRects[1]), 142);
    CGPathAddLineToPoint(linesPath, NULL, guideX, 142);
    CGPathAddLineToPoint(linesPath, NULL, guideX, 134+3);
    CGPathMoveToPoint(linesPath, NULL, CGRectGetMidX(bottomRects[2]), CGRectGetMinY(bottomRects[2]));
    CGPathAddLineToPoint(linesPath, NULL, CGRectGetMidX(bottomRects[2]), 142);
    CGPathAddLineToPoint(linesPath, NULL, maxX, 142);
    CGPathAddLineToPoint(linesPath, NULL, maxX, 134+3);
    _linesLayer.path = linesPath;
    CGPathRelease(linesPath);
    
//    CGMutablePathRef refPath = CGPathCreateMutable();
//    CGPathMoveToPoint(refPath, NULL, CGRectGetMidX(refRect), CGRectGetMaxY(refRect));
//    CGPathAddLineToPoint(refPath, NULL, CGRectGetMidX(refRect), 128);
//    CGPathAddLineToPoint(refPath, NULL, referenceX, 128);
//    CGPathAddLineToPoint(refPath, NULL, referenceX, 134-4);
//    _refLineLayer.path = refPath;
//    CGPathRelease(refPath);
    
    UIBezierPath *refPath = [UIBezierPath bezierPath];
    [refPath moveToPoint:CGPointMake(CGRectGetMidX(refRect), CGRectGetMaxY(refRect))];
    [refPath addLineToPoint:CGPointMake(CGRectGetMidX(refRect), 128)];
    [refPath addLineToPoint:CGPointMake(referenceX, 128)];
    [refPath addLineToPoint:CGPointMake(referenceX, 134-4)];
    _refLineLayer.path = refPath.CGPath;
}

- (void)showLineAnimated:(BOOL)animated {
    __block ShapeChartView *wself = self;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.5];
    [CATransaction setDisableActions:!animated];
    [CATransaction setCompletionBlock:^{
        _needDrawPoints = YES;
        [wself setNeedsDisplay];
    }];
    _linesLayer.strokeEnd = 1;
    _refLineLayer.strokeEnd = 1;
    [CATransaction commit];
}

- (void)dealloc {
    self.lineColor = nil;
    self.axisColor = nil;
    self.pointColor = nil;
    self.refPointColor = nil;
    self.topTextFont = nil;
    self.bottomTextFont = nil;
    
    self.data = nil;
    
    [super dealloc];
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawBackImage];
    
    [self drawTopText];
    
    [self drawBottomTextAndRects:context];
    
    [self drawRef:context];
    
    [self drawAxis:context];
    
    if (_needDrawPoints) {
        [self drawPoints:context];
    }
}

/**
 *  绘制背景图片
 */
- (void)drawBackImage {
    if (!self.data.image) return;
    
    [self.data.image drawInRect:self.bounds];
}

/**
 *  绘制上方文字
 */
- (void)drawTopText {
    
    //add top title text
    [self.lineColor set];
    for (int i = 0; i < 3; i++) {
        NSString *title = topTitles[i];
        CGRect rect = CGRectMake(0, 5, width/3., 10);
        rect.origin.x = width/3. * i;
        
        [title drawInRect:rect
                 withFont:[UIFont boldSystemFontOfSize:self.topTextFont.pointSize]
            lineBreakMode:NSLineBreakByWordWrapping
                alignment:NSTextAlignmentCenter];
    }
    //add top text
    [self.lineColor set];
    for (int i = 0; i < self.data.topDescriptions.count; i++) {
        if (i >= 3) break;
        
        NSString *topText = self.data.topDescriptions[i];
        CGRect rect = CGRectMake(0, 20, width/3., 10);
        rect.origin.x = width/3. * i;
        
        [topText drawInRect:rect
                   withFont:self.topTextFont
              lineBreakMode:NSLineBreakByWordWrapping
                  alignment:NSTextAlignmentCenter];
    }
}

/**
 *  绘制下方方框内的文字
 *
 *  @param context     context
 */
- (void)drawBottomTextAndRects:(CGContextRef)context {
    
    //add bottom rects -> 3
    CGContextSetLineWidth(context, kLineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextAddRects(context, bottomRects, 3);
    CGContextStrokePath(context);
    
    //draw bottom title text
    [[UIColor blackColor] set];
    for (int i = 0; i < 3; i++) {
        NSString *title = bottomTitles[i];
        CGRect rect = bottomRects[i];
        rect.size.height /= 2.0f;
        
        [title drawInRect:rect
                 withFont:[UIFont boldSystemFontOfSize:self.bottomTextFont.pointSize]
            lineBreakMode:NSLineBreakByWordWrapping
                alignment:NSTextAlignmentCenter];
    }
    //add bottom text
    [[UIColor blackColor] set];
    for (int i = 0; i < self.data.bottomDescriptions.count; i++) {
        if (i >= 3) break;
        
        NSString *bottomText = self.data.bottomDescriptions[i];
        CGRect rect = bottomRects[i];
        rect.size.height /= 2;
        rect.origin.y += rect.size.height;
        
        [bottomText drawInRect:rect
                      withFont:self.bottomTextFont
                 lineBreakMode:NSLineBreakByWordWrapping
                     alignment:NSTextAlignmentCenter];
    }
}

/**
 *  绘制参考成交价方框及文字
 *
 *  @param context context
 */
- (void)drawRef:(CGContextRef)context {
    //add ref rect
    CGContextSetLineWidth(context, kLineWidth);
    CGContextSetStrokeColorWithColor(context, self.refPointColor.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddRect(context, refRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGRect headRect = refRect;
    headRect.size.height *= 2./5.;
    CGContextSetFillColorWithColor(context, self.refPointColor.CGColor);
    CGContextAddRect(context, headRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    [[UIColor whiteColor] set];
    NSString *refTitle = @"参考成交价";
    [refTitle drawInRect:headRect withFont:[UIFont boldSystemFontOfSize:14]
           lineBreakMode:NSLineBreakByWordWrapping
               alignment:NSTextAlignmentCenter];
    
    //add ref text
    if (self.data.referencePrice) {
        [[UIColor blackColor] set];
        CGRect refTextRect = refRect;
        refTextRect.size.height *= 3./5.;
        refTextRect.origin.y += refRect.size.height /5. * 2.;
        [self.data.referencePrice drawInRect:refTextRect
                                    withFont:[UIFont boldSystemFontOfSize:14]
                               lineBreakMode:NSLineBreakByWordWrapping
                                   alignment:NSTextAlignmentCenter];
    }
}

- (void)drawAxis:(CGContextRef)context {
    //add x axis
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, self.axisColor.CGColor);
    CGContextMoveToPoint(context, 0, 134);
    CGContextAddLineToPoint(context, width, 134);
    CGContextStrokePath(context);
}

- (void)drawPoints:(CGContextRef)context {
    float minX          = width * self.data.minPricePercent;
    float maxX          = width * self.data.maxPricePercent;
    float referenceX    = width * self.data.referencePricePercent;
    float guideX        = width * self.data.guidePricePercent;
    
    //add points
    CGContextSetLineWidth(context, kLineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, self.pointColor.CGColor);
    CGContextAddArc(context, minX, 134, 3, 0, 2*M_PI, YES);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextAddArc(context, guideX, 134, 3, 0, 2*M_PI, YES);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextAddArc(context, maxX, 134, 3, 0, 2*M_PI, YES);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetFillColorWithColor(context, self.refPointColor.CGColor);
    CGContextAddArc(context, referenceX, 134, 4, 0, 2*M_PI, YES);
    CGContextDrawPath(context, kCGPathFillStroke);
    //
    //    //add line rect->point
    //    CGContextSetLineWidth(context, kLineWidth);
    //    CGContextSetStrokeColorWithColor(context, self.pointColor.CGColor);
    //
    //    CGContextMoveToPoint(context, minX, 134+3);
    //    CGContextAddLineToPoint(context, minX, 142);
    //    CGContextAddLineToPoint(context, CGRectGetMidX(bottomRects[0]), 142);
    //    CGContextAddLineToPoint(context, CGRectGetMidX(bottomRects[0]), CGRectGetMinY(bottomRects[0]));
    //    CGContextStrokePath(context);
    //
    //    CGContextMoveToPoint(context, guideX, 134+3);
    //    CGContextAddLineToPoint(context, guideX, 142);
    //    CGContextAddLineToPoint(context, CGRectGetMidX(bottomRects[1]), 142);
    //    CGContextAddLineToPoint(context, CGRectGetMidX(bottomRects[1]), CGRectGetMinY(bottomRects[1]));
    //    CGContextStrokePath(context);
    //
    //    CGContextMoveToPoint(context, maxX, 134+3);
    //    CGContextAddLineToPoint(context, maxX, 142);
    //    CGContextAddLineToPoint(context, CGRectGetMidX(bottomRects[2]), 142);
    //    CGContextAddLineToPoint(context, CGRectGetMidX(bottomRects[2]), CGRectGetMinY(bottomRects[2]));
    //    CGContextStrokePath(context);
    //
    //    //ref line rect->point
    //    CGContextSetStrokeColorWithColor(context, self.refPointColor.CGColor);
    //    CGContextMoveToPoint(context, referenceX, 134-4);
    //    CGContextAddLineToPoint(context, referenceX, 128);
    //    CGContextAddLineToPoint(context, CGRectGetMidX(refRect), 128);
    //    CGContextAddLineToPoint(context, CGRectGetMidX(refRect), CGRectGetMaxY(refRect));
    //    CGContextStrokePath(context);
}


@end




@implementation ShapeChartData

- (void)setResourceData:(NSDictionary *)resourceData {
    if (_resourceData != resourceData) {
        [_resourceData release];
        _resourceData = [resourceData retain];
        
        //-------TODO----------//
    }
}


- (id)init {
    self = [super init];
    if (self) {
        
        int i = arc4random();
        
        if (i%2) {
            _minPricePercent = .2;
            _guidePricePercent = .4;
            _maxPricePercent = .9;
            _referencePricePercent = .78;
        }else {
            _minPricePercent = 0;
            _guidePricePercent = .7;
            _maxPricePercent = 1;
            _referencePricePercent = .43;
        }
        
        self.topDescriptions = [NSArray arrayWithObjects:@"低于11.38万", @"11.38万-12.62万", @"高于12.62万", nil];
        self.bottomDescriptions = [NSArray arrayWithObjects:@"10.11万", @"12.63万", @"13.63万", nil];
        self.referencePrice = @"12.28万";
        
        self.image = [UIImage imageNamed:@"111.png"];
    }
    return self;
}

- (void)dealloc {
    self.topDescriptions = nil;
    self.bottomDescriptions = nil;
    self.referencePrice = nil;
    [super dealloc];
}


@end