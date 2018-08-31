//
//  HomeViewController.m
//  ADreamClusive
//
//  Created by ADreamClusive on 2018/8/31.
//  Copyright © 2018年 Jiaozl. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.greenColor;
    
//    SourceBundle   ADreamClusiveBundle
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    imgView.image = [UIImage imageNamed:@"SourceBundle.bundle/littlepet"];
    [self.view addSubview:imgView];
    
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"ADreamClusiveBundle" ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    //    UIViewController *vc = [[UIViewController alloc] initWithNibName:@"vc_name" bundle:resourceBundle];
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(120, 50, 100, 50)];
    imgView2.image = [UIImage imageNamed:@"buynew" inBundle:resourceBundle compatibleWithTraitCollection:nil];
    [self.view addSubview:imgView2];
    
    UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    imgView3.image = [UIImage imageNamed:@"demo"];
    [self.view addSubview:imgView3];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    sleep(3);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
