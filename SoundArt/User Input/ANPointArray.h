//
//  ANPointArray.h
//  SoundArt
//
//  Created by Alex Nichol on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANDrawnWave.h"

@interface ANPointArray : NSObject {
    CGPoint * points;
    NSUInteger pointCount;
    NSUInteger allocCount;
}

- (void)addPoint:(CGPoint)aPoint;
- (void)removePointAtIndex:(NSUInteger)index;
- (void)popPointsToX:(CGFloat)x;

- (NSUInteger)numberOfPoints;
- (CGPoint)pointAtIndex:(NSUInteger)index;

- (void)addPointsToPath:(CGContextRef)context;
- (ANDrawnWave *)normalizedWaveForHeight:(CGFloat)height;

@end
