//
//  ViewController.m
//  Chart
//
//  Created by dongdf on 14-4-16.
//  Copyright (c) 2014年 dongdf. All rights reserved.
//

#import "ViewController.h"
#import "ChartView.h"

@interface ViewController ()
{
    ChartView *chart;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    ChartData *data = [[ChartData alloc] init];    
    
    chart = [[ChartView alloc] initWithFrame:CGRectMake(0, 100, 320, 182)];
    chart.data = data;
    [self.view addSubview:chart];
}
- (IBAction)buttonPressed:(id)sender {
    ChartData *data = [[ChartData alloc] init];
    chart.data = data;
}


@end
