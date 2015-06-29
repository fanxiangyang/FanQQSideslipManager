//
//  ViewController.m
//  FanQQSideslipManager
//
//  Created by 向阳凡 on 15/6/6.
//  Copyright (c) 2015年 向阳凡. All rights reserved.
//

#import "ViewController.h"
#import "FanSideslipManager.h"
#import "FanLeftViewController.h"
#import "FanTabBarController.h"
#import "FanpushViewController.h"
#import "FanRightViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor greenColor];
    
    FanLeftViewController *leftVC=[FanLeftViewController new];
    FanRightViewController *rightVC=[FanRightViewController new];
    FanTabBarController *tabBarVC=[FanTabBarController new];
    [[FanSideslipManager shareInstance]fan_sideslipInitWithRootView:self.view leftViewcontroller:leftVC rightViewController:rightVC mainViewController:tabBarVC];
    
    [FanSideslipManager shareInstance].delegate=self;
    [FanSideslipManager shareInstance].fan_sideslipDerection=FanSideslipDirectionAll;

    // Do any additional setup after loading the view, typically from a nib.
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    FanpushViewController *push=[[FanpushViewController alloc]init];
//    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:push];
//    nav.navigationBar.translucent=NO;
//    nav.navigationBar.hidden=YES;
//    [self presentViewController:nav animated:YES completion:^{
//
//    }];
//}

#pragma mark - FanSideslipManagerDelegate
-(void)fanSideslipManager:(FanSideslipManager *)sideslipManager panGuesture:(UIPanGestureRecognizer *)pan{
    CGFloat x=[pan translationInView:sideslipManager.fan_rootView].x;
    NSLog(@"-----[实际距离：%f]------",x);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
