//
//  ANWaveGenerator.h
//  SoundMaker
//
//  Created by Alex Nichol on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ANWaveGenerator <NSObject>

- (Float32)amplitudeForX:(float *)xInOut;

@end
