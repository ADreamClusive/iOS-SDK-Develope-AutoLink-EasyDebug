//
//  ViewController.m
//  ADreamClusive
//
//  Created by ADreamClusive on 2018/8/31.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "ViewController.h"
#import "ADNewView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ADNewView *view = [[ADNewView alloc] initWithFrame:CGRectMake(200, 50, 100, 100)];
    
    [self.view addSubview:view];
    
    
    
}
- (IBAction)pushnewVC:(id)sender {
    
    HomeViewController *hvc = [[HomeViewController alloc] init];
    
    [self presentViewController:hvc animated:YES completion:nil];
    
}
    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
