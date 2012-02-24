//
//  ANWaveDrawer.m
//  SoundArt
//
//  Created by Alex Nichol on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANWaveDrawer.h"

@implementation ANWaveDrawer

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        wave = [ANDrawnWave sineWaveWithWidth:1];
    }
    return self;
}

- (void)setWave:(ANDrawnWave *)aWave {
    wave = aWave;
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];

    touchPoints = [[ANPointArray alloc] init];
    [touchPoints addPoint:point];
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [touchPoints popPointsToX:point.x];
    [touchPoints addPoint:point];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    wave = [touchPoints normalizedWaveForHeight:self.frame.size.height];
    touchPoints = nil;
    
    if ([delegate respondsToSelector:@selector(waveDrawer:drewWave:)]) {
        [delegate waveDrawer:self drewWave:wave];
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGPoint axisPoints[2] = {
        CGPointMake(0, floor(self.frame.size.height / 2) + 0.5),
        CGPointMake(self.frame.size.width, floor(self.frame.size.height / 2) + 0.5)
    };
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    CGContextSetLineWidth(context, 1);
    CGContextStrokeLineSegments(context, axisPoints, 2);
    
    CGContextSetLineWidth(context, 10);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextBeginPath(context);
    
    if (touchPoints) {
        [touchPoints addPointsToPath:context];
    } else {
        [wave addPointsToPath:context bounds:self.bounds];
    }
    
    CGContextStrokePath(context);
}

@end
