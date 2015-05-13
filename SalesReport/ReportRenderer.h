//
//  BNRReportRenderer.h
//  SalesReport
//
//  Created by Stephen Christopher on 11/18/14.
//  Copyright (c) 2014 Jonathan Blocksom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportRenderer : NSObject

@property (nonatomic, readonly) NSArray *persons;

- (id)initWithPersons:(NSArray *)persons;

// Assumes the context is flipped
- (void)drawInContext:(CGContextRef)ctx
               bounds:(CGRect)bounds;

// Just a stub that calls drawInContext:bounds:
- (void)drawLayer:(CALayer *)layer
        inContext:(CGContextRef)ctx;

@end
