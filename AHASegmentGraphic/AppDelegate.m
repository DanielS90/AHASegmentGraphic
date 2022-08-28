//
//  AppDelegate.m
//  AHASegmentGraphic
//
//  Created by Daniel Schroth on 22.08.22.
//

#import "AppDelegate.h"

#import "DSColorLut.h"
#import "DSRGBColor.h"
#import "DragDropImageView.h"
#import "DS2DMath.h"

#define DS_NSColorFromRGB(rgbValue) [NSColor colorWithCalibratedRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AppDelegate ()
@property (strong) IBOutlet NSWindow *window;

@property (strong) IBOutlet NSColorWell *color1;
@property (strong) IBOutlet NSColorWell *color2;
@property (strong) IBOutlet NSColorWell *color3;
@property (strong) IBOutlet NSColorWell *color4;
@property (strong) IBOutlet NSColorWell *color5;
@property (strong) IBOutlet NSColorWell *color6;

@property (strong) IBOutlet NSTextField *colorValue1;
@property (strong) IBOutlet NSTextField *colorValue2;
@property (strong) IBOutlet NSTextField *colorValue3;
@property (strong) IBOutlet NSTextField *colorValue4;
@property (strong) IBOutlet NSTextField *colorValue5;
@property (strong) IBOutlet NSTextField *colorValue6;

@property (strong) IBOutlet NSButton *showValuesCheckbox;

@property (strong) IBOutlet NSTextField *values;

@property (strong) IBOutlet DragDropImageView *resultImageView;

- (IBAction)selectLutPreset:(id)sender;
- (IBAction)renderImage:(id)sender;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    NSColor *c1 = nil;
    NSColor *c2 = nil;
    NSColor *c3 = nil;
    NSColor *c4 = nil;
    NSColor *c5 = nil;
    NSColor *c6 = nil;
    @try {
        c1 = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color1"]];
        c2 = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color2"]];
        c3 = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color3"]];
        c4 = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color4"]];
        c5 = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color5"]];
        c6 = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"color6"]];
    } @catch (NSException *exception) {
        
    }
    
    self.color1.color = c1 ? c1 : [NSColor whiteColor];
    self.color2.color = c2 ? c2 : [NSColor whiteColor];
    self.color3.color = c3 ? c3 : [NSColor whiteColor];
    self.color4.color = c4 ? c4 : [NSColor whiteColor];
    self.color5.color = c5 ? c5 : [NSColor whiteColor];
    self.color6.color = c6 ? c6 : [NSColor whiteColor];
    
    self.colorValue1.stringValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"colorValue1"] ? [[NSUserDefaults standardUserDefaults] stringForKey:@"colorValue1"] : @"";
    self.colorValue2.stringValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"colorValue2"] ? [[NSUserDefaults standardUserDefaults] stringForKey:@"colorValue2"] : @"";
    self.colorValue3.stringValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"colorValue3"] ? [[NSUserDefaults standardUserDefaults] stringForKey:@"colorValue3"] : @"";
    self.colorValue4.stringValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"colorValue4"] ? [[NSUserDefaults standardUserDefaults] stringForKey:@"colorValue4"] : @"";
    self.colorValue5.stringValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"colorValue5"] ? [[NSUserDefaults standardUserDefaults] stringForKey:@"colorValue5"] : @"";
    self.colorValue6.stringValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"colorValue6"] ? [[NSUserDefaults standardUserDefaults] stringForKey:@"colorValue6"] : @"";
    
    self.showValuesCheckbox.state = [[NSUserDefaults standardUserDefaults] boolForKey:@"showValuesCheckbox"] ? NSControlStateValueOn : NSControlStateValueOff;
    
    self.values.stringValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"values"] ? [[NSUserDefaults standardUserDefaults] stringForKey:@"values"] : @"";
    
    [self renderImage:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.color1.color] forKey:@"color1"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.color2.color] forKey:@"color2"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.color3.color] forKey:@"color3"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.color4.color] forKey:@"color4"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.color5.color] forKey:@"color5"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.color6.color] forKey:@"color6"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.colorValue1.stringValue forKey:@"colorValue1"];
    [[NSUserDefaults standardUserDefaults] setObject:self.colorValue2.stringValue forKey:@"colorValue2"];
    [[NSUserDefaults standardUserDefaults] setObject:self.colorValue3.stringValue forKey:@"colorValue3"];
    [[NSUserDefaults standardUserDefaults] setObject:self.colorValue4.stringValue forKey:@"colorValue4"];
    [[NSUserDefaults standardUserDefaults] setObject:self.colorValue5.stringValue forKey:@"colorValue5"];
    [[NSUserDefaults standardUserDefaults] setObject:self.colorValue6.stringValue forKey:@"colorValue6"];
    
    [[NSUserDefaults standardUserDefaults] setBool:self.showValuesCheckbox.state == NSControlStateValueOn forKey:@"showValuesCheckbox"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.values.stringValue forKey:@"values"];
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}


- (IBAction)renderImage:(id)sender
{
    DSColorLut *lut = [[DSColorLut alloc] init];
    
    if (self.colorValue1.stringValue.length > 0)
    {
        NSColor *color = [self.color1.color colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
        
        [lut addColor:[[DSRGBColor alloc] initWithR:color.redComponent
                                                  g:color.greenComponent
                                                  b:color.blueComponent]
             forValue:[NSNumber numberWithDouble:self.colorValue1.doubleValue]];
    }
    
    if (self.colorValue2.stringValue.length > 0)
    {
        NSColor *color = [self.color2.color colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
        
        [lut addColor:[[DSRGBColor alloc] initWithR:color.redComponent
                                                  g:color.greenComponent
                                                  b:color.blueComponent]
             forValue:[NSNumber numberWithDouble:self.colorValue2.doubleValue]];
    }
    
    if (self.colorValue3.stringValue.length > 0)
    {
        NSColor *color = [self.color3.color colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
        
        [lut addColor:[[DSRGBColor alloc] initWithR:color.redComponent
                                                  g:color.greenComponent
                                                  b:color.blueComponent]
             forValue:[NSNumber numberWithDouble:self.colorValue3.doubleValue]];
    }
    
    if (self.colorValue4.stringValue.length > 0)
    {
        NSColor *color = [self.color4.color colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
        
        [lut addColor:[[DSRGBColor alloc] initWithR:color.redComponent
                                                  g:color.greenComponent
                                                  b:color.blueComponent]
             forValue:[NSNumber numberWithDouble:self.colorValue4.doubleValue]];
    }
    
    if (self.colorValue5.stringValue.length > 0)
    {
        NSColor *color = [self.color5.color colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
        
        [lut addColor:[[DSRGBColor alloc] initWithR:color.redComponent
                                                  g:color.greenComponent
                                                  b:color.blueComponent]
             forValue:[NSNumber numberWithDouble:self.colorValue5.doubleValue]];
    }
    
    if (self.colorValue6.stringValue.length > 0)
    {
        NSColor *color = [self.color6.color colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
        
        [lut addColor:[[DSRGBColor alloc] initWithR:color.redComponent
                                                  g:color.greenComponent
                                                  b:color.blueComponent]
             forValue:[NSNumber numberWithDouble:self.colorValue6.doubleValue]];
    }
    
    
    double contextWidth = 1200.0;
    double contextHeight = 1000.0;
    NSBitmapImageRep* offscreenRep = [[NSBitmapImageRep alloc]
                                      initWithBitmapDataPlanes:NULL
                                      pixelsWide:(NSInteger)contextWidth
                                      pixelsHigh:(NSInteger)contextHeight
                                      bitsPerSample:8
                                      samplesPerPixel:4
                                      hasAlpha:YES
                                      isPlanar:NO
                                      colorSpaceName:NSDeviceRGBColorSpace
                                      bytesPerRow:0
                                      bitsPerPixel:0];

    NSGraphicsContext* nsContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:offscreenRep];
    [nsContext setImageInterpolation:NSImageInterpolationHigh];
    [nsContext setShouldAntialias:YES];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:nsContext];
    CGContextRef cgContext = [nsContext graphicsPort];
    CGContextSetInterpolationQuality(cgContext, kCGInterpolationHigh);
    
    // draw img
    [[NSColor whiteColor] setFill];
    NSRectFill(NSMakeRect(0, 0, contextWidth, contextHeight));
    
    if (self.values.stringValue.length > 0)
    {
        NSMutableCharacterSet *set = [NSMutableCharacterSet whitespaceCharacterSet];
        [set addCharactersInString:@"\n,"];
        NSArray *values = [self.values.stringValue componentsSeparatedByCharactersInSet:set];
        
        CGPoint centerPoint = CGPointMake(contextHeight / 2, contextHeight / 2);
        CGFloat graphicSize = 990;
        CGFloat segmentThickness = graphicSize / 8;
        for (int segment = 1; segment <= 17; segment++)
        {
            NSColor *color = [NSColor whiteColor];
            NSString *text = @"";
            if (values.count >= segment)
            {
                text = [values objectAtIndex:segment - 1];
                color = text.length > 0 ? [[lut interpolatedColorForValue:[NSNumber numberWithDouble:text.doubleValue]] convertToColor] : [NSColor whiteColor];
            }
            color = [color colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
            [color setFill];
            CGFloat colorBrightness = color.redComponent * 0.299 + color.greenComponent * 0.587 + color.blueComponent * 0.114;
            
            [[NSColor blackColor] setStroke];
            NSBezierPath *path = [NSBezierPath bezierPath];
            CGPoint textCenter;
            if (segment < 7)
            {
                CGFloat outerRadius = graphicSize - centerPoint.y;
                CGFloat innerRadius = graphicSize - segmentThickness - centerPoint.y;
                textCenter = CGPointMake(centerPoint.x + (outerRadius + innerRadius) / 2.0, centerPoint.y);
                if (segment == 1)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:60 endAngle:120 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:120 endAngle:60 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(90));
                }
                else if (segment == 2)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:120 endAngle:180 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:180 endAngle:120 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(150));
                }
                else if (segment == 3)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:180 endAngle:240 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:240 endAngle:180 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(210));
                }
                else if (segment == 4)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:240 endAngle:300 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:300 endAngle:240 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(270));
                }
                else if (segment == 5)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:300 endAngle:360 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:360 endAngle:300 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(330));
                }
                else if (segment == 6)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:0 endAngle:60 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:60 endAngle:0 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(390));
                }
            }
            else if (segment < 13)
            {
                CGFloat outerRadius = graphicSize - segmentThickness - centerPoint.y;
                CGFloat innerRadius = graphicSize - 2 * segmentThickness - centerPoint.y;
                textCenter = CGPointMake(centerPoint.x + (outerRadius + innerRadius) / 2.0, centerPoint.y);
                if (segment == 7)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:60 endAngle:120 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:120 endAngle:60 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(90));
                }
                else if (segment == 8)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:120 endAngle:180 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:180 endAngle:120 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(150));
                }
                else if (segment == 9)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:180 endAngle:240 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:240 endAngle:180 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(210));
                }
                else if (segment == 10)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:240 endAngle:300 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:300 endAngle:240 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(270));
                }
                else if (segment == 11)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:300 endAngle:360 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:360 endAngle:300 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(330));
                }
                else if (segment == 12)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:0 endAngle:60 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:60 endAngle:0 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(390));
                }
            }
            else if (segment < 17)
            {
                CGFloat outerRadius = graphicSize - 2 * segmentThickness - centerPoint.y;
                CGFloat innerRadius = graphicSize - 3 * segmentThickness - centerPoint.y;
                textCenter = CGPointMake(centerPoint.x + (outerRadius + innerRadius) / 2.0, centerPoint.y);
                if (segment == 13)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:45 endAngle:135 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:135 endAngle:45 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(90));
                }
                else if (segment == 14)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:135 endAngle:225 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:225 endAngle:135 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(180));
                }
                else if (segment == 15)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:225 endAngle:315 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:315 endAngle:225 clockwise:YES];
                    textCenter = DSRotatePointClockwise(textCenter, centerPoint, DSDegreeToRadians(270));
                }
                else if (segment == 16)
                {
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:315 endAngle:405 clockwise:NO];
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:405 endAngle:315 clockwise:YES];
                }
            }
            else if (segment == 17)
            {
                CGFloat outerRadius = graphicSize - 3 * segmentThickness - centerPoint.y;
                [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:0 endAngle:360 clockwise:NO];
                textCenter = centerPoint;
            }
            [path fill];
            if (text.length > 0 && self.showValuesCheckbox.state == NSControlStateValueOn)
            {
                NSAttributedString *str = [[NSAttributedString alloc] initWithString:text
                                                                          attributes:@{NSForegroundColorAttributeName : colorBrightness > 0.3 ? [NSColor blackColor] : [NSColor whiteColor],
                                                                                       NSFontAttributeName : [NSFont fontWithName:@"Times New Roman Bold" size:35]
                                                                                     }];
                NSSize strSize = [str size];
                [str drawInRect:NSMakeRect(textCenter.x - strSize.width / 2.0,
                                           textCenter.y - strSize.height / 2.0,
                                           strSize.width, strSize.height)];
            }
            
            for (int segment = 1; segment <= 17; segment++)
            {
                NSBezierPath *path = [NSBezierPath bezierPath];
                [path setLineWidth:1];
                if (segment < 7)
                {
                    CGFloat outerRadius = graphicSize - centerPoint.y;
                    CGFloat innerRadius = graphicSize - segmentThickness - centerPoint.y;
                    if (segment == 1)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:60 endAngle:120 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:120 endAngle:60 clockwise:YES];
                    }
                    else if (segment == 2)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:120 endAngle:180 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:180 endAngle:120 clockwise:YES];
                    }
                    else if (segment == 3)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:180 endAngle:240 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:240 endAngle:180 clockwise:YES];
                    }
                    else if (segment == 4)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:240 endAngle:300 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:300 endAngle:240 clockwise:YES];
                    }
                    else if (segment == 5)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:300 endAngle:360 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:360 endAngle:300 clockwise:YES];
                    }
                    else if (segment == 6)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:0 endAngle:60 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:60 endAngle:0 clockwise:YES];
                    }
                }
                else if (segment < 13)
                {
                    CGFloat outerRadius = graphicSize - segmentThickness - centerPoint.y;
                    CGFloat innerRadius = graphicSize - 2 * segmentThickness - centerPoint.y;
                    if (segment == 7)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:60 endAngle:120 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:120 endAngle:60 clockwise:YES];
                    }
                    else if (segment == 8)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:120 endAngle:180 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:180 endAngle:120 clockwise:YES];
                    }
                    else if (segment == 9)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:180 endAngle:240 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:240 endAngle:180 clockwise:YES];
                    }
                    else if (segment == 10)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:240 endAngle:300 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:300 endAngle:240 clockwise:YES];
                    }
                    else if (segment == 11)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:300 endAngle:360 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:360 endAngle:300 clockwise:YES];
                    }
                    else if (segment == 12)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:0 endAngle:60 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:60 endAngle:0 clockwise:YES];
                    }
                }
                else if (segment < 17)
                {
                    CGFloat outerRadius = graphicSize - 2 * segmentThickness - centerPoint.y;
                    CGFloat innerRadius = graphicSize - 3 * segmentThickness - centerPoint.y;
                    if (segment == 13)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:45 endAngle:135 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:135 endAngle:45 clockwise:YES];
                    }
                    else if (segment == 14)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:135 endAngle:225 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:225 endAngle:135 clockwise:YES];
                    }
                    else if (segment == 15)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:225 endAngle:315 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:315 endAngle:225 clockwise:YES];
                    }
                    else if (segment == 16)
                    {
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:315 endAngle:405 clockwise:NO];
                        [path appendBezierPathWithArcWithCenter:centerPoint radius:innerRadius startAngle:405 endAngle:315 clockwise:YES];
                    }
                }
                else if (segment == 17)
                {
                    CGFloat outerRadius = graphicSize - 3 * segmentThickness - centerPoint.y;
                    [path appendBezierPathWithArcWithCenter:centerPoint radius:outerRadius startAngle:0 endAngle:360 clockwise:NO];
                }
            }
            [[NSColor colorWithWhite:0.0 alpha:1.0] setStroke];
            [path setLineWidth:2];
            [path stroke];
        }
    }
    
    
    
    
    
    
    //draw lut
    [[NSColor blackColor] setFill];
    [[NSColor blackColor] setStroke];
    NSGradient *lutGradient = [lut convertToGradient];
    [lutGradient drawInRect:NSMakeRect(contextHeight + 35, 100, 50, contextHeight - 200) angle:90];
    NSBezierPath *lutRect = [NSBezierPath bezierPathWithRect:NSMakeRect(contextHeight + 35, 100, 50, contextHeight - 200)];
    [lutRect setLineWidth:2.0];
    [lutRect stroke];
    
    NSArray<NSNumber *> *lutValues = [lut allValuesAsc];
    if ([lutValues count] > 1)
    {
        NSNumber *max = [lutValues valueForKeyPath:@"@max.self"];
        NSNumber *min = [lutValues valueForKeyPath:@"@min.self"];
        double dMin = min.doubleValue;
        double dRange = max.doubleValue - min.doubleValue;
        for (NSNumber *val in lutValues)
        {
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:val.stringValue
                                                                      attributes:@{NSForegroundColorAttributeName : [NSColor blackColor],
                                                                                   NSFontAttributeName : [NSFont fontWithName:@"Times New Roman Bold" size:35]
                                                                                 }];
            NSSize strSize = [str size];
            if (val == lutValues.firstObject)
            {
                [str drawInRect:NSMakeRect(contextHeight + 125, 100 - 10, contextWidth - (contextHeight + 110), strSize.height)];
                NSRectFill(NSMakeRect(contextHeight + 90, 100, 25, 2));
            }
            else if (val == lutValues.lastObject)
            {
                [str drawInRect:NSMakeRect(contextHeight + 125, contextHeight - 100 - strSize.height + 10, contextWidth - (contextHeight + 110), strSize.height)];
                NSRectFill(NSMakeRect(contextHeight + 90, contextHeight - 100 - 2, 25, 2));
            }
            else
            {
                double loc = (val.doubleValue - dMin) / dRange;
                [str drawInRect:NSMakeRect(contextHeight + 125, 100 + (contextHeight - 200) * loc - strSize.height / 2.0, contextWidth - (contextHeight + 110), strSize.height)];
                NSRectFill(NSMakeRect(contextHeight + 90, 100 + (contextHeight - 200) * loc - 1, 25, 2));
            }
        }
        
    }
    
    [NSGraphicsContext restoreGraphicsState];
    NSData *tiffData = [offscreenRep TIFFRepresentation];
    NSImage *image = [[NSImage alloc] initWithData:tiffData];
    self.resultImageView.image = image;
}

- (IBAction)selectLutPreset:(id)sender
{
    NSArray<NSString *> *presetNames = @[@"Segmental Percentage", @"MOLLI 1.5T", @"MOLLI 3T", @"T2 Map", @"Z-Score Average"];
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@""];
    [alert setIcon:nil];
    alert.alertStyle = NSAlertStyleInformational;
    [alert addButtonWithTitle:@"Cancel"];
    for (NSString *name in presetNames)
    {
        [alert addButtonWithTitle:name];
    }
    [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
        NSInteger presetIndex = returnCode - NSAlertSecondButtonReturn;
        
        if (presetIndex == 0)
        {
            self.color1.color = [NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            self.colorValue1.stringValue = @"0";
            self.color2.color = [NSColor clearColor];
            self.colorValue2.stringValue = @"";
            self.color3.color = [NSColor clearColor];
            self.colorValue3.stringValue = @"";
            self.color4.color = [NSColor clearColor];
            self.colorValue4.stringValue = @"";
            self.color5.color = [NSColor clearColor];
            self.colorValue5.stringValue = @"";
            self.color6.color = DS_NSColorFromRGB(0x1f78b4); //blue
            self.colorValue6.stringValue = @"15";
        }
        else if (presetIndex == 1)
        {
            self.color1.color = [NSColor colorWithRed:0 green:0 blue:1.0 alpha:1.0];
            self.colorValue1.stringValue = @"250";
            self.color2.color = [NSColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0];
            self.colorValue2.stringValue = @"700";
            self.color3.color = [NSColor colorWithRed:0.0 green:1.0 blue:0.1 alpha:1.0];
            self.colorValue3.stringValue = @"900";
            self.color4.color = [NSColor colorWithRed:0.1 green:1.0 blue:0.0 alpha:1.0];
            self.colorValue4.stringValue = @"1100";
            self.color5.color = [NSColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
            self.colorValue5.stringValue = @"1300";
            self.color6.color = [NSColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            self.colorValue6.stringValue = @"1750";
        }
        else if (presetIndex == 2)
        {
            self.color1.color = [NSColor colorWithRed:0 green:0 blue:1.0 alpha:1.0];
            self.colorValue1.stringValue = @"250";
            self.color2.color = [NSColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0];
            self.colorValue2.stringValue = @"800";
            self.color3.color = [NSColor colorWithRed:0.0 green:1.0 blue:0.1 alpha:1.0];
            self.colorValue3.stringValue = @"1000";
            self.color4.color = [NSColor colorWithRed:0.1 green:1.0 blue:0.0 alpha:1.0];
            self.colorValue4.stringValue = @"1250";
            self.color5.color = [NSColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
            self.colorValue5.stringValue = @"1450";
            self.color6.color = [NSColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            self.colorValue6.stringValue = @"1750";
        }
        else if (presetIndex == 3)
        {
            self.color1.color = [NSColor colorWithRed:0 green:0 blue:1.0 alpha:1.0];
            self.colorValue1.stringValue = @"0";
            self.color2.color = [NSColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
            self.colorValue2.stringValue = @"20";
            self.color3.color = [NSColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
            self.colorValue3.stringValue = @"40";
            self.color4.color = [NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
            self.colorValue4.stringValue = @"";
            self.color5.color = [NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
            self.colorValue5.stringValue = @"";
            self.color6.color = [NSColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            self.colorValue6.stringValue = @"60";
        }
        else if (presetIndex == 4)
        {
            self.color1.color = DS_NSColorFromRGB(0x1f78b4); //blue
            self.colorValue1.stringValue = @"-3";
            self.color2.color = [NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]; //white
            self.colorValue2.stringValue = @"0";
            self.color3.color = [NSColor clearColor];
            self.colorValue3.stringValue = @"";
            self.color4.color = [NSColor clearColor];
            self.colorValue4.stringValue = @"";
            self.color5.color = [NSColor clearColor];
            self.colorValue5.stringValue = @"";
            self.color6.color = DS_NSColorFromRGB(0xe31a1c); //red
            self.colorValue6.stringValue = @"3";
        }
        
        [self renderImage:nil];
    }];
}

@end
