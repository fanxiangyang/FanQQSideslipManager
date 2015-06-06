//
//  FanTabBarController.m
//  QQSlide
//
//  Created by 向阳凡 on 15/6/6.
//  Copyright (c) 2015年 向阳凡. All rights reserved.
//

#import "FanTabBarController.h"
#import "FanHomeViewController.h"
#import "OtherPageViewController.h"
#import "FanNavigationController.h"

@interface FanTabBarController ()

@end

@implementation FanTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    FanHomeViewController *home1=[[FanHomeViewController alloc]init];
    FanNavigationController *nav1=[[FanNavigationController alloc]initWithRootViewController:home1];
    nav1.title=@"home";
    OtherPageViewController *other1=[[OtherPageViewController alloc]init];
    FanNavigationController *nav2=[[FanNavigationController alloc]initWithRootViewController:other1];
    nav2.title=@"other";
    self.viewControllers=@[nav1,nav2];
    NSArray *selectImageNameArray=@[@"image/move.png",@"move.png"];
    NSArray *unSelectImageNameArray=@[@"unmove.png",@"unmove.png"];

    NSArray *title=@[@"home",@"other"];
    for (int i=0; i<self.tabBar.items.count; i++) {
        UITabBarItem *item=self.tabBar.items[i];
        //选中图片
        UIImage *selectImage=[UIImage imageNamed:selectImageNameArray[i]];
        
        //未选中图片
        UIImage *unSelectImage=[UIImage imageNamed:unSelectImageNameArray[i]];
//        if (IOS7_8) {
            //去除蓝色阴影效果
            //             [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            //             [unSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item =[item initWithTitle:title[i] image:[unSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            //item =[item initWithTitle:title[i] image:unSelectImage selectedImage:selectImage];
//        }else{
//            [item setFinishedSelectedImage:selectImage withFinishedUnselectedImage:unSelectImage];
//            item.title=title[i];
//        }
    }

    
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
