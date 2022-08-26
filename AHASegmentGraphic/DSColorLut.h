//
//  DSColorLut.h
//  DST1Curve
//
//  Created by Daniel Schroth on 21.07.22.
//

#import <Cocoa/Cocoa.h>

@class DSRGBColor;

NS_ASSUME_NONNULL_BEGIN

@interface DSColorLut : NSObject
- (void)addColor:(DSRGBColor *)color forValue:(NSNumber *)value;
- (NSNumber *)valueForColor:(DSRGBColor *)color;
- (void)removeColor:(DSRGBColor *)color;

- (NSArray<DSRGBColor *> *)allColors;
- (NSArray<NSNumber *> *)allValuesAsc; //ascending

- (DSRGBColor *)interpolatedColorForValue:(NSNumber *)value;
- (NSGradient *)convertToGradient;
@end

NS_ASSUME_NONNULL_END
