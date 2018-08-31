//
//  ViewController.m
//  ADSDKDemo
//
//  Created by ADreamClusive on 2018/8/31.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ViewController.h"
#import <ADreamClusiveSDK/ADreamClusiveSDK.h>
#import "ADreamClusiveStaticSDK.h"
#import "ADNewView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    ADView *view = [[ADView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    
    [self.view addSubview:view];

    [ADreamClusiveStaticSDK sayHello];

    [ADreamClusiveStaticSDK sayGoodBye];
    
    ADNewView *view1 = [[ADNewView alloc] initWithFrame:CGRectMake(170, 170, 100, 100)];
    
    [self.view addSubview:view1];
}

- (IBAction)goHome:(id)sender {
    
    HomeViewController *hvc = [[HomeViewController alloc] init];
    
    [self presentViewController:hvc animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
