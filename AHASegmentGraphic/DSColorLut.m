//
//  DSColorLut.m
//  DST1Curve
//
//  Created by Daniel Schroth on 21.07.22.
//

#import "DSColorLut.h"
#import "DSRGBColor.h"

@interface DSColorLut ()
@property (strong) NSMutableDictionary<NSNumber *, DSRGBColor *> *colorValues;

- (DSRGBColor *)lowerNeighborForValue:(NSNumber *)value;
- (DSRGBColor *)upperNeighborForValue:(NSNumber *)value;
@end

@implementation DSColorLut
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.colorValues = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addColor:(DSRGBColor *)color forValue:(NSNumber *)value
{
    [self.colorValues setObject:color forKey:value];
}
- (NSNumber *)valueForColor:(DSRGBColor *)color
{
    return [[self.colorValues allKeysForObject:color] firstObject];
}
- (void)removeColor:(DSRGBColor *)color
{
    [self.colorValues removeObjectsForKeys:[self.colorValues allKeysForObject:color]];
}

- (NSArray<DSRGBColor *> *)allColors
{
    return [self.colorValues allValues];
}

- (NSArray<NSNumber *> *)allValuesAsc
{
    return [[self.colorValues allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

- (DSRGBColor *)lowerNeighborForValue:(NSNumber *)value
{
    double dValue = value.doubleValue;
    
    double minDist = DBL_MAX;
    DSRGBColor *result = nil;
    
    for (NSNumber *val in self.colorValues.allKeys)
    {
        double diff = dValue - val.doubleValue;
        if (diff >= 0 && diff < minDist)
        {
            minDist = diff;
            result = [self.colorValues objectForKey:val];
        }
    }
    
    return result;
}

- (DSRGBColor *)upperNeighborForValue:(NSNumber *)value
{
    double dValue = value.doubleValue;
    
    double minDist = DBL_MAX;
    DSRGBColor *result = nil;
    
    for (NSNumber *val in self.colorValues.allKeys)
    {
        double diff = val.doubleValue - dValue;
        if (diff >= 0 && diff < minDist)
        {
            minDist = diff;
            result = [self.colorValues objectForKey:val];
        }
    }
    
    return result;
}

- (DSRGBColor *)interpolatedColorForValue:(NSNumber *)value
{
    DSRGBColor *lower = [self lowerNeighborForValue:value];
    DSRGBColor *upper = [self upperNeighborForValue:value];
    
    if (lower && upper)
    {
        double dVal = value.doubleValue;
        double dLow = [self valueForColor:lower].doubleValue;
        double dUp = [self valueForColor:upper].doubleValue;
        
        double dTotal = dUp - dLow;
        if (dTotal == 0)
        {
            //we're exactly on a key value
            return upper;
        }
        else
        {
            double dPart = (dVal - dLow) / dTotal;
            
            return [[DSRGBColor alloc] initWithR:dPart * upper.r + (1.0 - dPart) * lower.r
                                               g:dPart * upper.g + (1.0 - dPart) * lower.g
                                               b:dPart * upper.b + (1.0 - dPart) * lower.b];
        }
    }
    else if (lower)
    {
        return lower;
    }
    else if (upper)
    {
        return upper;
    }
    else
    {
        return nil;
    }
}

- (NSGradient *)convertToGradient
{
    NSMutableArray *colors = [NSMutableArray array];
    CGFloat *locations = malloc(self.colorValues.count * sizeof(CGFloat));
    
    NSArray *allValues = self.colorValues.allKeys;
    NSNumber *max = [allValues valueForKeyPath:@"@max.self"];
    NSNumber *min = [allValues valueForKeyPath:@"@min.self"];
    double dMin = min.doubleValue;
    double dRange = max.doubleValue - min.doubleValue;
    
    int counter = 0;
    for (NSNumber *val in allValues)
    {
        [colors addObject:[[self.colorValues objectForKey:val] convertToColor]];
        CGFloat loc = (val.doubleValue - dMin) / dRange;
        locations[counter] = loc;
        counter++;
    }
    
    NSGradient *result = [[NSGradient alloc] initWithColors:colors atLocations:locations colorSpace:[NSColorSpace genericRGBColorSpace]];
    free(locations);
    return result;
}
@end
