//
//  BNRViewController.m
//  SalesReport
//
//  Created by Jonathan Blocksom on 4/1/13.
//  Copyright (c) 2013 Jonathan Blocksom. All rights reserved.
//

#import "ReportViewController.h"
#import "Person.h"
#import "ReportRenderer.h"

@interface ReportViewController ()

@property CALayer *reportLayer;
@property (nonatomic) ReportRenderer *reportRenderer;

@end

@implementation ReportViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Set up people
        Person *fred = [[Person alloc] initWithName:@"Fred"
                                                    image:nil];
        fred.sales = 134;

        Person *matt = [[Person alloc] initWithName:@"Matt"
                                                    image:nil];
        matt.sales = 312;

        // Feel free to add your own people!

        NSArray *persons = @[fred, matt];

        self.reportRenderer = [[ReportRenderer alloc] initWithPersons:persons];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.reportLayer = [CALayer layer];
    self.reportLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    self.reportLayer.geometryFlipped = YES;
    self.reportLayer.delegate = self.reportRenderer;

    // Put it atop the view
    [self.view.layer addSublayer:self.reportLayer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.toValue = [NSValue valueWithCGPoint:CGPointZero];
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(-600.0f, 0.0f)];
    [self.reportLayer addAnimation:anim forKey:@"slide"];
}

- (void)viewDidLayoutSubviews {
    CGRect bounds = self.view.bounds;

    bounds.size.height -= 60; // leave space fo the buttons

    self.reportLayer.bounds = bounds;
    self.reportLayer.anchorPoint = CGPointZero;
    self.reportLayer.position = CGPointZero;
    [self.reportLayer setNeedsDisplay];
}
@end
