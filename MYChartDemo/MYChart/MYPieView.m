//
//  MYPieView.m
//  MYChartDemo
//
//  Created by yuan zhi on 3/26/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import "MYPieView.h"
#import "MYPieLayer.h"
#import "MYSliceLayer.h"
#import "MYPieValues.h"

static float const kBTSPieViewSelectionOffset = 20.0f;

#pragma mark - Function Helpers
CGPathRef CGPathCreateArc(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle) {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, center.x, center.y);
    CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, false);
    CGPathCloseSubpath(path);
    return path;
}

void MYUpdateLabelPosition(CALayer *labelLayer, CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle) {
    CGFloat midAngle = (startAngle + endAngle) / 2.0f;
    CGFloat halfRadius = radius / 1.8f;
    [labelLayer setPosition:CGPointMake((CGFloat) (center.x + (halfRadius * cos(midAngle))), (CGFloat) (center.y + (halfRadius * sin(midAngle))))];
}

CGFloat MYLookupPreviousLayerAngle(NSArray *pieLayers, NSUInteger currentPieLayerIndex, CGFloat defaultAngle) {
    MYSliceLayer *sliceLayer;
    if (currentPieLayerIndex == 0) {
        sliceLayer = nil;
    } else {
        sliceLayer = [pieLayers objectAtIndex:currentPieLayerIndex - 1];
    }
    
    return (sliceLayer == nil) ? defaultAngle : [[sliceLayer presentationLayer] sliceAngle];
}

void MYUpdateLayers(NSArray *sliceLayers, NSArray *labelLayers, NSUInteger layerIndex, CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle) {
    {
        CAShapeLayer *sliceLayer = [sliceLayers objectAtIndex:layerIndex];
        
        CGPathRef path = CGPathCreateArc(center, radius, startAngle, endAngle);
        [sliceLayer setPath:path];
        CFRelease(path);
    }
    
    {
        CALayer *labelLayer = [labelLayers objectAtIndex:layerIndex];
        MYUpdateLabelPosition(labelLayer, center, radius, startAngle, endAngle);
    }
}


@interface MYPieView () {
    
    NSInteger _selectedSliceIndex;
    CADisplayLink *_displayLink;
    NSMutableArray *_animations;
    CGPoint _center;
    CGFloat _radius;
    CGFloat startRotateAngle;
    
    NSNumberFormatter *_labelFormatter;
}
@end

@implementation MYPieView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    
    return self;
}

- (void)initView
{
    startRotateAngle = -M_PI/2.0f;
    initAngle = startRotateAngle;
    rotateAngle = 0;
 
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapGesture];
    
    _labelFormatter = [[NSNumberFormatter alloc] init];
    [_labelFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    _selectedSliceIndex = -1;
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTimerFired:)];
    [_displayLink setPaused:YES];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    _animations = [[NSMutableArray alloc] init];
    
    self.legendPosition = MYLegendBottom;
}

- (void)dealloc
{
    [_displayLink invalidate];
    _displayLink = nil;
}

+ (Class)layerClass
{
    return [MYPieLayer class];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, kTitleHeight);
    
    CGRect legendFrame = [self.legendView legendFrameWithPosition:self.legendPosition];
    switch (self.legendPosition) {
        case MYLegendTop:
            
            break;
        case MYLegendRight:
            
            break;
        case MYLegendBottom:
            self.legendView.frame = legendFrame;
            break;
        case MYLegendLeft:
            
            break;
        default:
            break;
    }
    
    CGRect parentLayerBounds = [[self layer] bounds];
    CGFloat centerX = parentLayerBounds.size.width / 2.0f;
    CGFloat centerY = (parentLayerBounds.size.height - legendFrame.size.height) / 2.0f;
    _center = CGPointMake(centerX, centerY);
    _radius = MIN(centerX, centerY - kTitleHeight) - 15;
}

#pragma mark - MYLegendViewDelegate
- (void)legendView:(MYLegendView *)legendView didSelectSection:(NSInteger)section
{
    [self.legendView.legendStateArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj boolValue] && section != idx) {
            [self legendView:self.legendView cancelSelectSection:idx];
            [self.legendView.legendStateArray replaceObjectAtIndex:idx withObject:@(NO)];
        }
    }];
    
    MYPieLayer *pieLayer = (MYPieLayer *) [self layer];
    NSArray *sliceLayers = [[pieLayer sliceLayers] sublayers];
    NSArray *labelLayers = [[pieLayer labelLayers] sublayers];
    MYSliceLayer *sliceLayer = [sliceLayers objectAtIndex:section];
    
    double endAngle = [sliceLayer sliceAngle]+rotateAngle;
    CGFloat startAngle = MYLookupPreviousLayerAngle(sliceLayers, section, startRotateAngle)+rotateAngle;
    CGFloat deltaAngle = (CGFloat) (((endAngle + startAngle) / 2.0));

    CGFloat x = (CGFloat) (kBTSPieViewSelectionOffset * cos(deltaAngle));
    CGFloat y = (CGFloat) (kBTSPieViewSelectionOffset * sin(deltaAngle));
    
    CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(x, y);
    [sliceLayer setAffineTransform:translationTransform];
    
    [[labelLayers objectAtIndex:section] setAffineTransform:translationTransform];
    
    self.titleLabel.text = [self.dataSource chartView:self displayValueForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    
}

- (void)legendView:(MYLegendView *)legendView cancelSelectSection:(NSInteger)section
{
    MYPieLayer *pieLayer = (MYPieLayer *) [self layer];
    NSArray *sliceLayers = [[pieLayer sliceLayers] sublayers];
    NSArray *labelLayers = [[pieLayer labelLayers] sublayers];
    MYSliceLayer *sliceLayer = [sliceLayers objectAtIndex:section];
    
    [sliceLayer setAffineTransform:CGAffineTransformIdentity];
    [[labelLayers objectAtIndex:section] setAffineTransform:CGAffineTransformIdentity];
    [sliceLayer setZPosition:0];
    
    self.titleLabel.text = @"";
}

- (void)beginCATransaction
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:self.animationDuration];
}

- (CGFloat)initialLabelAngleForSliceAtIndex:(NSUInteger)currentIndex sliceCount:(NSUInteger)sliceCount startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    // The inserted layer animates differently depending on where the new layer is inserted.
    CGFloat initialLabelAngle;
    
    if (currentIndex == 0) {
        initialLabelAngle = startAngle;
    } else if (currentIndex + 1 == sliceCount) {
        initialLabelAngle = endAngle;
    } else {
        MYPieLayer *pieLayer = (MYPieLayer *) [self layer];
        NSArray *pieLayers = [[pieLayer sliceLayers] sublayers];
        initialLabelAngle = MYLookupPreviousLayerAngle(pieLayers, currentIndex, initAngle);
    }
    return initialLabelAngle;
}

+ (CATextLayer *)createLabelLayer
{
    CATextLayer *textLayer = [CATextLayer layer];
    [textLayer setContentsScale:[[UIScreen mainScreen] scale]];
    CGFontRef font = CGFontCreateWithFontName((__bridge CFStringRef) [[UIFont fontWithName:@"Helvetica" size:17] fontName]);
    [textLayer setFont:font];
    CFRelease(font);
    [textLayer setFontSize:17.0];
    [textLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont systemFontOfSize:17.0]
                                 };
    CGSize size = [@"100.00%" sizeWithAttributes:attributes];
    [textLayer setBounds:CGRectMake(0, 0.0, size.width, size.height)];
    return textLayer;
}

- (MYSliceLayer *)insertSliceLayerAtIndex:(NSUInteger)index color:(UIColor *)color
{
    MYSliceLayer *sliceLayer = [MYSliceLayer layerWithColor:[color CGColor]];
    MYPieLayer *pieLayer = (MYPieLayer *) [self layer];
    [[pieLayer sliceLayers] insertSublayer:sliceLayer atIndex:(unsigned)index];
    return sliceLayer;
}

- (CATextLayer *)insertLabelLayerAtIndex:(NSUInteger)index value:(double)value
{
    CATextLayer *labelLayer = [MYPieView createLabelLayer];
    [labelLayer setString:[_labelFormatter stringFromNumber:@(value)]];
    
    MYPieLayer *pieLayer = (MYPieLayer *) [self layer];
    CALayer *layer = [pieLayer labelLayers];
    [layer insertSublayer:labelLayer atIndex:(unsigned)index];
    return labelLayer;
}

- (MYSliceLayer *)insertSliceAtIndex:(NSUInteger)index values:(MYPieValues *)values startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    NSUInteger sliceCount = values.sliceCount;
    UIColor *color = [self.dataSource chartView:self colorInSection:index];
    
    MYSliceLayer *sliceLayer = [self insertSliceLayerAtIndex:index color:color];
    sliceLayer.delegate = self;
    
    CGFloat initialLabelAngle = [self initialLabelAngleForSliceAtIndex:index sliceCount:sliceCount startAngle:startAngle endAngle:endAngle];
    CATextLayer *labelLayer = [self insertLabelLayerAtIndex:index value:[[values.percentArray objectAtIndex:index] doubleValue]];
    MYUpdateLabelPosition(labelLayer, _center, _radius, initialLabelAngle, initialLabelAngle);
    
    return sliceLayer;
}

- (void)reloadData
{
    MYPieLayer *parentLayer = (MYPieLayer *) [self layer];
    [parentLayer removeAllPieLayers];
    
    if (self.dataSource) {
        
        [self beginCATransaction];
        
        NSUInteger sliceCount = [self.dataSource numberOfSectionsInChartView:self];
        
        MYPieValues *values = [[MYPieValues alloc] initWithSliceCount:sliceCount block:^(NSUInteger sliceIndex) {
            return [self.dataSource chartView:self valueForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sliceIndex]];
        }];

        
        CGFloat startAngle = initAngle;
        CGFloat endAngle = startAngle;
        
        for (NSUInteger currentIndex = 0; currentIndex < sliceCount; currentIndex++) {
            
            // Make no implicit transactions are creating (e.g. when adding the new slice we don't want a "fade in" effect)
            [CATransaction setDisableActions:YES];
            
            endAngle += [[values.anglesArray objectAtIndex:currentIndex] doubleValue];
            
            MYSliceLayer *sliceLayer = [self insertSliceAtIndex:currentIndex values:values startAngle:startAngle endAngle:endAngle];
      
            [CATransaction setDisableActions:NO];
            
            // Remember because "sliceAngle" is a dynamic property this ends up calling the actionForLayer:forKey: method on each layer with a non-nil delegate
            [sliceLayer setSliceAngle:endAngle];
            [sliceLayer setDelegate:nil];
            
            startAngle = endAngle;
        }
        
        [CATransaction commit];
    }
}


#pragma mark - 手势

- (void)tap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [gesture locationInView:self];
        MYPieLayer *pieLayer = (MYPieLayer *) [self layer];
        NSArray *sliceLayers = [[pieLayer sliceLayers] sublayers];
        
        [sliceLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
            MYSliceLayer *sliceLayer = (MYSliceLayer *) obj;
            CGPathRef path = [sliceLayer path];
            
            CGAffineTransform transform = CGAffineTransformInvert(sliceLayer.affineTransform);
            // NOTE: in this demo code, the touch handling does not know about any applied transformations (i.e. perspective)
            if (CGPathContainsPoint(path, &transform, point, 1)) {
                if ([[self.legendView.legendStateArray objectAtIndex:index] boolValue]) {
                    [self.legendView.legendStateArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:NO]];
                    [self legendView:self.legendView cancelSelectSection:index];
                }
                else
                {
                    [self.legendView.legendStateArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
                    [self legendView:self.legendView didSelectSection:index];
                }
                *stop = YES;
                [self.legendView setNeedsDisplay];
            }
        }];
    }
}

CGFloat startRotation;
bool isRedyRotation;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    float dx = point.x - _center.x;
    float dy = point.y - _center.y;
    if (sqrt(pow(dx, 2) + pow(dy, 2)) < _radius) {
        isRedyRotation = YES;
        startRotation = atan2(dy,dx);
    }
    else
    {
        isRedyRotation = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isRedyRotation) {
        return;
    }
    else
    {
        [self.legendView.legendStateArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj boolValue]) {
                [self legendView:self.legendView cancelSelectSection:idx];
                [self.legendView.legendStateArray replaceObjectAtIndex:idx withObject:@(NO)];
            }
        }];
    }
    
    void(^getName)(NSString * a) = ^(NSString *a) {
        NSLog(@"a");
    };
    getName(@"good");
    
//    BOOL (^getName)(int a,int b) = ^(int a, int b) {
//        return YES;
//    };
//    getName (1,3);
    
    BOOL (^test)( id obj, NSUInteger idx, BOOL *stop);
    test = ^ ( id obj, NSUInteger idx, BOOL *stop) {
        return NO ;
    };
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    CGFloat dx = point.x - _center.x;
    CGFloat dy = point.y - _center.y;
    CGFloat rotation = atan2(dy,dx) - startRotation;

    initAngle = rotation + rotateAngle;
    
    MYPieLayer *parentLayer = (MYPieLayer *) [self layer];
    NSArray *pieLayers = [[parentLayer sliceLayers] sublayers];
    NSArray *labelLayers = [[parentLayer labelLayers] sublayers];
    
    CGPoint center = _center;
    CGFloat radius = _radius;
    
    [CATransaction setDisableActions:YES];
    
    NSUInteger index = 0;
    for (MYPieLayer *currentPieLayer in pieLayers) {
        MYSliceLayer *sliceLayer;
        if (index == 0) {
            sliceLayer = nil;
        } else {
            sliceLayer = [pieLayers objectAtIndex:index - 1];
        }
        
        CGFloat interpolatedStartAngle = (sliceLayer == nil) ? initAngle +startRotateAngle : [sliceLayer sliceAngle] + initAngle;
        
        
        MYSliceLayer *presentationLayer = (MYSliceLayer *) currentPieLayer;
        CGFloat interpolatedEndAngle = [presentationLayer sliceAngle]+initAngle;
        MYUpdateLayers(pieLayers, labelLayers, index, center, radius, interpolatedStartAngle, interpolatedEndAngle);
        ++index;
    }
    [CATransaction setDisableActions:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isRedyRotation) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGFloat dx = point.x - _center.x;
    CGFloat dy = point.y - _center.y;
    CGFloat rotation = atan2(dy,dx);
    rotateAngle += rotation - startRotation;
}


#pragma mark - Animation Delegate + CADisplayLink Callback

- (void)updateTimerFired:(CADisplayLink *)displayLink
{
    MYPieLayer *parentLayer = (MYPieLayer *) [self layer];
    NSArray *pieLayers = [[parentLayer sliceLayers] sublayers];
    NSArray *labelLayers = [[parentLayer labelLayers] sublayers];
    
    CGPoint center = _center;
    CGFloat radius = _radius;
    
    [CATransaction setDisableActions:YES];
    
    NSUInteger index = 0;
    for (MYPieLayer *currentPieLayer in pieLayers) {
        CGFloat interpolatedStartAngle = MYLookupPreviousLayerAngle(pieLayers, index, initAngle);
        MYSliceLayer *presentationLayer = (MYSliceLayer *) [currentPieLayer presentationLayer];
        CGFloat interpolatedEndAngle = [presentationLayer sliceAngle];
        
        MYUpdateLayers(pieLayers, labelLayers, index, center, radius, interpolatedStartAngle, interpolatedEndAngle);
        ++index;
    }
    [CATransaction setDisableActions:NO];
}

- (void)animationDidStart:(CAAnimation *)animation
{
    [_displayLink setPaused:NO];
    [_animations addObject:animation];
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)animationCompleted
{
    [_animations removeObject:animation];
    
    if ([_animations count] == 0) {
        [_displayLink setPaused:YES];
    }
}

#pragma mark - Layer Animation Delegate
- (id <CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    if ([@"sliceAngle" isEqualToString:event]) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"sliceAngle"];
        [animation setFromValue:[NSNumber numberWithDouble:initAngle]];
        [animation setDelegate:self];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        return animation;
    } else {
        return nil;
    }
}
@end
