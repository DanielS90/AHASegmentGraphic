//
//  DSRGBColor.m
//  DST1Curve
//
//  Created by Daniel Schroth on 21.07.22.
//

#import "DSRGBColor.h"

@implementation DSRGBColor
- (instancetype)initWithR:(float)r g:(float)g b:(float)b
{
    self = [super init];
    if (self) {
        self.r = r;
        self.g = g;
        self.b = b;
    }
    return self;
}

- (NSColor *)convertToColor
{
    return [NSColor colorWithRed:self.r green:self.g blue:self.b alpha:1.0];
}
@end
