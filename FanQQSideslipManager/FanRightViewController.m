//
//  FanRightViewController.m
//  FanQQSideslipManager
//
//  Created by 向阳凡 on 15/6/7.
//  Copyright (c) 2015年 向阳凡. All rights reserved.
//

#import "FanRightViewController.h"

@interface FanRightViewController ()

@end

@implementation FanRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor magentaColor];
    
    
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    lable.backgroundColor=[UIColor whiteColor];
    lable.text=@"1234567890";
    [self.view addSubview:lable];

    // Do any additional setup after loading the view.
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
