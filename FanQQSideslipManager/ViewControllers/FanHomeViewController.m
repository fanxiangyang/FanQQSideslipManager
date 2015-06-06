//
//  FanHomeViewController.m
//  QQSlide
//
//  Created by 向阳凡 on 15/6/6.
//  Copyright (c) 2015年 向阳凡. All rights reserved.
//

#import "FanHomeViewController.h"
#import "FanSideslipManager.h"

@interface FanHomeViewController ()

@end

@implementation FanHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor yellowColor];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"push to secoundVC" forState:UIControlStateNormal];
    btn.frame=CGRectMake(0, 0, 200, 30);
    [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    btn.center=self.view.center;
    [btn addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view.
}
-(void)pushVC{
    UIViewController *vc=[[UIViewController alloc]init];
    vc.view.backgroundColor=[UIColor darkGrayColor];
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[FanSideslipManager shareInstance] fan_addPanGesture];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[FanSideslipManager shareInstance] fan_removePanGesture];
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
