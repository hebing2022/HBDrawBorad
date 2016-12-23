//
//  CustomBorad.m
//  CustomDrawBorad
//
//  Created by hebing on 16/12/23.
//  Copyright © 2016年 hebing. All rights reserved.
//

#import "CustomBorad.h"
#import "HBShapLayer.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface CustomBorad()

@property (nonatomic, strong) NSMutableArray *LayerArray;

@property (nonatomic, strong) HBShapLayer *drawLayer;

@property (nonatomic, strong) UIBezierPath *beganPath;

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) UIColor *lineColor;

@end
@implementation CustomBorad
- (void)initialize
{
    self.LayerArray = [NSMutableArray new];
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
 
    self.lineWidth = 2.0f;
    self.lineColor = [UIColor redColor];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
        [self initialize];

        [self createSubViews];
        
        
    }
    
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint beganPoint = [touch locationInView:self];
    [self drawBeganPoint:beganPoint];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    //上一个点的坐标
    CGPoint previousPoint = [touch previousLocationInView:self];
    CGPoint middlePoint = midPoint(previousPoint,currentPoint);
    [self drawControlPoint:middlePoint EndPoint:currentPoint];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    CGPoint previousPoint = [touch previousLocationInView:self];
    CGPoint middlePoint = midPoint(previousPoint,currentPoint);
    [self drawControlPoint:middlePoint EndPoint:currentPoint];
}
- (void)drawBeganPoint:(CGPoint)point
{
    
    HBShapLayer *drawLayer = [HBShapLayer layer];
    drawLayer.lineWidth = self.lineWidth;
    drawLayer.fillColor = [UIColor clearColor].CGColor;
    drawLayer.strokeColor = self.lineColor.CGColor;
    _drawLayer = drawLayer;
    _drawLayer.isPen = YES;
    [self.layer addSublayer:_drawLayer];
    
    [_LayerArray addObject:drawLayer];
    
    UIBezierPath *beganPath = [UIBezierPath bezierPath];
    [beganPath moveToPoint:point];
    _beganPath = beganPath;
    
}
- (void)drawControlPoint:(CGPoint)controlPoint EndPoint:(CGPoint)point
{
    [_beganPath addQuadCurveToPoint:point controlPoint:controlPoint];
    _drawLayer.path = _beganPath.CGPath;
}
// 计算中间点
CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}
- (void)createSubViews
{

    UIButton *rubberButton = [UIButton new];
    rubberButton.frame = CGRectMake(0, self.frame.size.height - 40, SCREENWIDTH/4, 40);
    [rubberButton setTitle:@"橡皮" forState:UIControlStateNormal];
    rubberButton.backgroundColor = [UIColor greenColor];
    [rubberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rubberButton addTarget:self action:@selector(rubberAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rubberButton];
    
    UIButton *penButton = [UIButton new];
    penButton.frame = CGRectMake(rubberButton.frame.size.width, self.frame.size.height - 40, SCREENWIDTH/4, 40);
    [penButton setTitle:@"笔" forState:UIControlStateNormal];
    [penButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    penButton.backgroundColor = [UIColor greenColor];
    [penButton addTarget:self action:@selector(writeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:penButton];
    
    UIButton *clearButton = [UIButton new];
    clearButton.frame = CGRectMake(CGRectGetMaxX(penButton.frame), CGRectGetMinY(penButton.frame), SCREENWIDTH/4, 40);
    clearButton.backgroundColor = [UIColor greenColor];
    [clearButton setTitle:@"清除" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearButton];
    
    UIButton *saveButton = [UIButton new];
    saveButton.frame = CGRectMake(CGRectGetMaxX(clearButton.frame), CGRectGetMinY(clearButton.frame), SCREENWIDTH/4, 40);
    saveButton.backgroundColor = [UIColor greenColor];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveButton];
}
- (void)rubberAction:(UIButton *)sender
{
    self.lineWidth = 20.0f;
    self.lineColor = self.backgroundColor;
    _drawLayer.isPen = NO;
}
- (void)writeAction:(UIButton *)sender
{
    self.lineWidth = 2.0f;
    self.lineColor = [UIColor redColor];
    _drawLayer.isPen = YES;
}
- (void)clearAction:(UIButton *)sender
{
    self.lineWidth = 2.0f;
    self.lineColor = [UIColor redColor];
    _drawLayer.isPen = YES;
    
    [_LayerArray enumerateObjectsUsingBlock:^(HBShapLayer  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj removeFromSuperlayer];
    }];
    
    [_LayerArray removeAllObjects];

}
- (void)saveAction:(UIButton *)sender
{
    UIImageWriteToSavedPhotosAlbum([self getImageFromView:self], self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败";
    }else{
        msg = @"保存图片成功";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
//将UIView转成UIImage
-(UIImage *)getImageFromView:(UIView *)theView
{
     // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, NO, [UIScreen mainScreen].scale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

