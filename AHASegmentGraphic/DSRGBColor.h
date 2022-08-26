//
//  DSRGBColor.h
//  DST1Curve
//
//  Created by Daniel Schroth on 21.07.22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface DSRGBColor : NSObject
@property (assign) float r; //0...1
@property (assign) float g; //0...1
@property (assign) float b; //0...1

- (instancetype)initWithR:(float)r g:(float)g b:(float)b;
- (NSColor *)convertToColor;
@end

NS_ASSUME_NONNULL_END
