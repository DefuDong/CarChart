//
//  ViewController.m
//  ShapeChart
//
//  Created by dongdf on 14-4-18.
//  Copyright (c) 2014年 dongdf. All rights reserved.
//

#import "ViewController.h"
#import "ChartView.h"
#import "ShapeChartView.h"

@interface ViewController ()
{
    ChartView *chartView;
    ShapeChartView *shapeView;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view from its nib.
    
    chartView = [[ChartView alloc] initWithFrame:CGRectMake(0, 50, 320, 182)];
    chartView.data = [[ChartData alloc] init];
    [self.view addSubview:chartView];
    
    
    shapeView = [[ShapeChartView alloc] initWithFrame:CGRectMake(0, 300, 320, 182)];
    shapeView.data = [[ShapeChartData alloc] init];
    [self.view addSubview:shapeView];
}

- (void)viewDidAppear:(BOOL)animated {
    
}


- (IBAction)buttonPressed:(id)sender {
    [shapeView showLineAnimated:YES];
}

@end
