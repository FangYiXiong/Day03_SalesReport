//
//  BNRReportRenderer.m
//  SalesReport
//
//  Created by Stephen Christopher on 11/18/14.
//  Copyright (c) 2014 Jonathan Blocksom. All rights reserved.
//

#import "ReportRenderer.h"

#import "Person.h"

#define RANGE (700.0f)
// RANGE is the range of values that are OK

#define B_MARGIN (10.0f)
// B_MARGIN is the bottom margin in points

#define T_MARGIN (10.0f)
// T_MARGIN is the top margin in points

#define H_GAP (10.4f)
// H_GAP is the gap between the bars and side margins

@interface ReportRenderer (){
    CGImageRef backgroundImage;
    CGRect backgroundRect;
}

@property (nonatomic, strong) NSArray *persons;
@property (nonatomic, strong) UIFont  *nameFont;
@property (nonatomic, strong) UIFont  *amountFont;

@end

@implementation ReportRenderer

- (id)initWithPersons:(NSArray *)persons
{
    self = [super init];
    if (self) {
        self.persons = persons;
        
        UIImage *tempImage = [UIImage imageNamed:@"flowers.jpg"];
        backgroundImage = tempImage.CGImage;
        CGImageRetain(backgroundImage);
        
        backgroundRect.origin = CGPointZero;
        backgroundRect.size = tempImage.size;
        
        self.nameFont = [UIFont fontWithName:@"Palatino-BoldItalic" size:95.0];
        self.amountFont = [UIFont fontWithName:@"Verdana-Bold" size:30.0];
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
               bounds:(CGRect)bounds
{
    NSLog(@"Drawing in %@", NSStringFromCGRect(bounds));

    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();

    CGFloat blackRGBA[] = { 0, 0, 0, 1 };
    CGColorRef black = CGColorCreate(cs, blackRGBA);

    CGFloat whiteRGBA[] = { 1, 1, 1, 1 };
    CGColorRef white = CGColorCreate(cs, whiteRGBA);

    CGContextSetStrokeColorWithColor(ctx, black);
    CGContextSetLineWidth(ctx, 1);

    CGContextSetFillColorWithColor(ctx, white);

    float minY = CGRectGetMinY(bounds) + B_MARGIN;
    float maxY = CGRectGetMaxY(bounds) + T_MARGIN;
    float increment = (maxY - minY) / RANGE;

    NSUInteger personCount = [self.persons count];
    float totalHGaps = (personCount + 2) * H_GAP; // personCount + 1
    float barWidth = (bounds.size.width - totalHGaps) / personCount;

    // Draw the bars
    CGRect barRect;
    barRect.size.width = barWidth;
    barRect.origin.y = minY;

    int idx=0;
    for (Person *person in self.persons) {
        barRect.origin.x = bounds.origin.x + H_GAP + (barWidth + H_GAP) * idx;
        barRect.size.height = increment * person.sales;

//        CGPathRef barPath = CGPathCreateWithRect(barRect, NULL);
        CGPathRef barPath  = CGPathCreateWithRoundedRect(barRect, 7.0, 7.0, NULL);
//        CGContextAddPath(ctx, barPath);
//        CGContextFillPath(ctx);
        
        // Fill the bar with flowers
        CGContextSaveGState(ctx);
        CGContextAddPath(ctx, barPath);
        CGContextClip(ctx);
        CGContextDrawImage(ctx, backgroundRect, backgroundImage);
        CGContextRestoreGState(ctx);

        // Fill path clears the current path, so add it again
        CGContextAddPath(ctx, barPath);
        CGContextStrokePath(ctx);
        CGPathRelease(barPath);
        
        // Create attributed string for sales label
        NSString *soldString = [NSString stringWithFormat:@"%d units", person.sales];
        
        
        
        
        CGContextSaveGState(ctx);
        CGContextSetShadow(ctx, CGSizeMake(8, -9), 4.0);

        //  Draw the photo
        CGRect photoRect;
        photoRect.origin.x = barRect.origin.x;
        photoRect.origin.y = CGRectGetMaxY(barRect);
        photoRect.size = person.photo.size;
        CGContextDrawImage(ctx, photoRect, person.photo.CGImage);
        
        NSLog(@"barRect's fram = %@",NSStringFromCGRect(barRect));
        NSLog(@"PhotoRect's fram = %@",NSStringFromCGRect(photoRect));
        
        CGContextRestoreGState(ctx);
        
        idx++;
    }

    CGColorRelease(white);
    CGColorRelease(black);

    CGColorSpaceRelease(cs);
}

- (void)drawLayer:(CALayer *)layer
        inContext:(CGContextRef)ctx
{
    [self drawInContext:ctx bounds:layer.bounds];
}

- (void)dealloc{
    CGImageRelease(backgroundImage);
}

@end
