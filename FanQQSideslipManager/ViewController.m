//
//  ViewController.m
//  FanQQSideslipManager
//
//  Created by 向阳凡 on 15/6/6.
//  Copyright (c) 2015年 向阳凡. All rights reserved.
//

#import "ViewController.h"
#import "FanSideslipManager/FanSideslipManager.h"
#import "ViewControllers/FanLeftViewController.h"
#import "ViewControllers/FanTabBarController.h"
#import "ViewControllers/FanpushViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor greenColor];
    
    FanLeftViewController *leftVC=[FanLeftViewController new];
    FanTabBarController *tabBarVC=[FanTabBarController new];
    [[FanSideslipManager shareInstance]fan_sideslipInitWithRootView:self.view leftViewcontroller:leftVC tabBarController:tabBarVC];
    // Do any additional setup after loading the view, typically from a nib.
}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    FanpushViewController *push=[[FanpushViewController alloc]init];
//    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:push];
//    [self presentViewController:nav animated:YES completion:^{
//
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
