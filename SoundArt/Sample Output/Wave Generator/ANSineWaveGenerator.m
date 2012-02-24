//
//  ANSineWaveGenerator.m
//  SoundMaker
//
//  Created by Alex Nichol on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANSineWaveGenerator.h"

@implementation ANSineWaveGenerator

- (Float32)amplitudeForX:(float *)xInOut {
    while (*xInOut > 1) *xInOut -= 1;
    return (Float32)sinf(*xInOut * M_PI * 2);
}

@end
