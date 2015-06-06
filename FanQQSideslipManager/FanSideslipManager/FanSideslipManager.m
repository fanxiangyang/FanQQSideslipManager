//
//  FanSideslipManager.m
//  QQSlide
//
//  Created by 向阳凡 on 15/6/6.
//  Copyright (c) 2015年 向阳凡. All rights reserved.
//

#import "FanSideslipManager.h"

@implementation FanSideslipManager

static FanSideslipManager *manager=nil;
+(FanSideslipManager *)shareInstance{
    if (manager==nil) {
        manager=[[FanSideslipManager alloc]init];
    }
    return manager;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        _fan_leftOffSet=0.0;
        _fan_rightOffSet=0.0;
        _fan_distance=0.0;
        _fan_proportion=0.77;
        _fan_fullDistance=0.78;
        _fan_proportionOfLeftView=1.0;
        _fan_distanceOfLeftView=kFanScreenWidth*(1-self.fan_fullDistance);
        _fan_panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(fan_pan:)];
        _fan_tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fan_showHome)];
    }
    return self;
}


-(void)fan_sideslipInitWithRootView:(UIView *)rootView leftViewcontroller:(UIViewController *)leftViewController tabBarController:(UITabBarController *)tabBarController{
    self.fan_leftViewController=leftViewController;
    self.fan_rootView=rootView;
    self.fan_tabBarController=tabBarController;
    
//    if (kFanScreenWidth>320) {
//        self.fan_proportionOfLeftView=kFanScreenWidth/320.0;
//        self.fan_distanceOfLeftView=(kFanScreenWidth-320.0)*self.fan_fullDistance/2;
//    }
    leftViewController.view.center=CGPointMake(leftViewController.view.center.x-self.fan_distanceOfLeftView, leftViewController.view.center.y);
//    leftViewController.view.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.fan_fullDistance,self.fan_fullDistance);
    self.fan_centerOfLeftViewAtBeginning=leftViewController.view.center;
    [rootView addSubview:leftViewController.view];
    // 增加黑色遮罩层，实现视差特效
    self.fan_blackCoverView=[[UIView alloc]initWithFrame:rootView.frame];
    self.fan_blackCoverView.backgroundColor=[UIColor blackColor];
    [rootView addSubview:self.fan_blackCoverView];
    self.fan_mainView=[[UIView alloc]initWithFrame:rootView.frame];
    [self.fan_mainView addSubview:tabBarController.view];
    [tabBarController.view bringSubviewToFront:tabBarController.tabBar];
    [rootView addSubview:self.fan_mainView];
    [leftViewController.view bringSubviewToFront:rootView];

    [self.fan_mainView addGestureRecognizer:_fan_panGesture];
    
}
-(void)fan_pan:(UIPanGestureRecognizer *)pan{
    CGFloat x=[pan translationInView:self.fan_rootView].x;
    CGFloat trueDistance=self.fan_distance+x;//实时距离
    CGFloat trueProportion=trueDistance/(kFanScreenWidth*self.fan_fullDistance);
    // 如果 UIPanGestureRecognizer 结束，则激活自动停靠
    if (pan.state == UIGestureRecognizerStateEnded ){
        
        if (trueDistance > kFanScreenWidth* (self.fan_proportion / 3)) {
            [self fan_showLeft];
        }else if (trueDistance < kFanScreenWidth * -(self.fan_proportion / 3)) {
            [self fan_showRight];
        } else {
            [self fan_showHome];
        }
        
        return;
    }
    
    // 计算缩放比例
    CGFloat proportion= pan.view.frame.origin.x >= 0 ? -1 : 1;
    proportion *=trueDistance /kFanScreenWidth;
//     NSLog(@"-----[比例1：%d]------",proportion);
    proportion *= 1 - self.fan_proportion ;
    proportion /= self.fan_fullDistance + self.fan_proportion /2 - 0.5;
    proportion += 1.0;
    if (proportion <= self.fan_proportion) { // 若比例已经达到最小，则不再继续动画
        return;
    }
//    NSLog(@"-----[比例：%d]------",proportion);
    // 执行视差特效
    self.fan_blackCoverView.alpha = (proportion - self.fan_proportion) / (1 - self.fan_proportion);
    // 执行平移和缩放动画
    pan.view.center = CGPointMake(self.fan_rootView.center.x + trueDistance, self.fan_rootView.center.y);
    pan.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
    
    // 执行左视图动画
    CGFloat pro = self.fan_fullDistance + (self.fan_proportionOfLeftView - self.fan_fullDistance) * trueProportion;
    self.fan_leftViewController.view.center = CGPointMake(self.fan_centerOfLeftViewAtBeginning.x + self.fan_distanceOfLeftView * trueProportion, self.fan_centerOfLeftViewAtBeginning.y - (self.fan_proportionOfLeftView - 1) * self.fan_leftViewController.view.frame.size.height * trueProportion / 2 );
    self.fan_leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, pro, pro);
}
//展示左视图
-(void)fan_showLeft{
    [self.fan_mainView addGestureRecognizer:self.fan_tapGesture];
    self.fan_distance=self.fan_rootView.center.x*(self.fan_fullDistance*2+self.fan_proportion-1)+self.fan_leftOffSet;
    [self fan_sideslipAnimateScaleProportion:self.fan_proportion direction:FanSideslipDirectionLeft];
}
//展示右视图
-(void)fan_showRight{
    [self.fan_mainView addGestureRecognizer:self.fan_tapGesture];
    self.fan_distance=self.fan_rootView.center.x*(1-(self.fan_fullDistance*2+self.fan_proportion-1))+self.fan_rightOffSet;
    [self fan_sideslipAnimateScaleProportion:self.fan_proportion direction:FanSideslipDirectonRight];
}
//展示主视图
-(void)fan_showHome{
    [self.fan_mainView removeGestureRecognizer:self.fan_tapGesture];
    self.fan_distance=0.0;
    [self fan_sideslipAnimateScaleProportion:1.0 direction:FanSideslipDirectionLeft];
}

-(void)fan_sideslipAnimateScaleProportion:(CGFloat)scaleProportion direction:(FanSideslipDirection)direction{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.fan_mainView.center=CGPointMake(self.fan_rootView.center.x+self.fan_distance, self.fan_rootView.center.y);
        self.fan_mainView.transform= CGAffineTransformScale(CGAffineTransformIdentity, scaleProportion, scaleProportion);
        if (direction == FanSideslipDirectionLeft) {
            self.fan_leftViewController.view.center = CGPointMake(self.fan_centerOfLeftViewAtBeginning.x + self.fan_distanceOfLeftView, self.fan_leftViewController.view.center.y);
            self.fan_leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.fan_proportionOfLeftView, self.fan_proportionOfLeftView);
        }
//        else if(direction==FanSideslipDirectonRight){
//            self.fan_leftViewController.view.center = self.fan_rootView.center;
//            self.fan_leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
//        }
        self.fan_blackCoverView.alpha = direction == FanSideslipDirectionCetenr ? 1 : 0;
        self.fan_leftViewController.view.alpha = direction == FanSideslipDirectonRight ? 0 : 1;
        
    } completion:nil];
}

-(void)fan_removePanGesture{
    [self.fan_mainView removeGestureRecognizer:self.fan_panGesture];
}
-(void)fan_addPanGesture{
    [self.fan_mainView addGestureRecognizer:self.fan_panGesture];
}
#pragma mark - get set
-(void)setFan_fullDistance:(CGFloat)fan_fullDistance{
    if (fan_fullDistance>0.6) {
        _fan_fullDistance=fan_fullDistance;
        if (fan_fullDistance<_fan_proportion) {
            _fan_fullDistance=_fan_proportion+0.01;
        }
    }else{
        _fan_fullDistance=0.78;
    }
}
-(void)setFan_proportion:(CGFloat)fan_proportion{
    if (fan_proportion>0.6) {
        _fan_proportion=fan_proportion;
    }else{
        _fan_proportion=0.77;
    }

}


#pragma mark - 版本1.0 bug:左视图缩放比例及坐标有问题

//-(void)fan_sideslipInitWithRootView:(UIView *)rootView leftViewcontroller:(UIViewController *)leftViewController tabBarController:(UITabBarController *)tabBarController{
//    self.fan_leftViewController=leftViewController;
//    self.fan_rootView=rootView;
//    self.fan_tabBarController=tabBarController;
//    
//    if (kFanScreenWidth>320) {
//        self.fan_proportionOfLeftView=kFanScreenWidth/320.0;
//        self.fan_distanceOfLeftView=(kFanScreenWidth-320.0)*self.fan_fullDistance/2;
//    }
//    leftViewController.view.center=CGPointMake(leftViewController.view.center.x-50, leftViewController.view.center.y);
//    leftViewController.view.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
//    leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
//    self.fan_centerOfLeftViewAtBeginning=leftViewController.view.center;
//    [rootView addSubview:leftViewController.view];
//    // 增加黑色遮罩层，实现视差特效
//    self.fan_blackCoverView=[[UIView alloc]initWithFrame:rootView.frame];
//    self.fan_blackCoverView.backgroundColor=[UIColor blackColor];
//    [rootView addSubview:self.fan_blackCoverView];
//    self.fan_mainView=[[UIView alloc]initWithFrame:rootView.frame];
//    [self.fan_mainView addSubview:tabBarController.view];
//    [tabBarController.view bringSubviewToFront:tabBarController.tabBar];
//    [rootView addSubview:self.fan_mainView];
//    [leftViewController.view bringSubviewToFront:rootView];
//    
//    [self.fan_mainView addGestureRecognizer:_fan_panGesture];
//    
//}
//-(void)fan_pan:(UIPanGestureRecognizer *)pan{
//    CGFloat x=[pan translationInView:self.fan_rootView].x;
//    CGFloat trueDistance=self.fan_distance+x;//实时距离
//    CGFloat trueProportion=trueDistance/(kFanScreenWidth*self.fan_fullDistance);
//    // 如果 UIPanGestureRecognizer 结束，则激活自动停靠
//    if (pan.state == UIGestureRecognizerStateEnded ){
//        
//        if (trueDistance > kFanScreenWidth* (self.fan_proportion / 3)) {
//            [self fan_showLeft];
//        }else if (trueDistance < kFanScreenWidth * -(self.fan_proportion / 3)) {
//            [self fan_showRight];
//        } else {
//            [self fan_showHome];
//        }
//        
//        return;
//    }
//    // 计算缩放比例
//    CGFloat proportion= pan.view.frame.origin.x >= 0 ? -1 : 1;
//    proportion *= trueDistance / kFanScreenWidth;
//    proportion *= 1 - self.fan_proportion ;
//    proportion /= self.fan_fullDistance + self.fan_proportion /2 - 0.5;
//    proportion += 1;
//    if (proportion <= self.fan_proportion) { // 若比例已经达到最小，则不再继续动画
//        return;
//    }
//    
//    // 执行视差特效
//    self.fan_blackCoverView.alpha = (proportion - self.fan_proportion) / (1 - self.fan_proportion);
//    // 执行平移和缩放动画
//    pan.view.center = CGPointMake(self.fan_rootView.center.x + trueDistance, self.fan_rootView.center.y);
//    pan.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, proportion, proportion);
//    
//    // 执行左视图动画
//    CGFloat pro = 0.8 + (self.fan_proportionOfLeftView - 0.8) * trueProportion;
//    self.fan_leftViewController.view.center = CGPointMake(self.fan_centerOfLeftViewAtBeginning.x + self.fan_distanceOfLeftView * trueProportion, self.fan_centerOfLeftViewAtBeginning.y - (self.fan_proportionOfLeftView - 1) * self.fan_leftViewController.view.frame.size.height * trueProportion / 2 );
//    self.fan_leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, pro, pro);
//    
//}
////展示左视图
//-(void)fan_showLeft{
//    [self.fan_mainView addGestureRecognizer:self.fan_tapGesture];
//    self.fan_distance=self.fan_rootView.center.x*(self.fan_fullDistance*2+self.fan_proportion-1);
//    [self fan_sideslipAnimateScaleProportion:self.fan_proportion direction:FanSideslipDirectionLeft];
//}
////展示右视图
//-(void)fan_showRight{
//    [self.fan_mainView addGestureRecognizer:self.fan_tapGesture];
//    self.fan_distance=self.fan_rootView.center.x*(1-(self.fan_fullDistance*2+self.fan_proportion-1));
//    [self fan_sideslipAnimateScaleProportion:self.fan_proportion direction:FanSideslipDirectonRight];
//}
////展示主视图
//-(void)fan_showHome{
//    [self.fan_mainView removeGestureRecognizer:self.fan_tapGesture];
//    self.fan_distance=0.0;
//    [self fan_sideslipAnimateScaleProportion:1.0 direction:FanSideslipDirectionLeft];
//}
//
//-(void)fan_sideslipAnimateScaleProportion:(CGFloat)scaleProportion direction:(FanSideslipDirection)direction{
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.fan_mainView.center=CGPointMake(self.fan_rootView.center.x+self.fan_distance, self.fan_rootView.center.y);
//        self.fan_mainView.transform= CGAffineTransformScale(CGAffineTransformIdentity, scaleProportion, scaleProportion);
//        if (direction == FanSideslipDirectionLeft) {
//            self.fan_leftViewController.view.center = CGPointMake(self.fan_centerOfLeftViewAtBeginning.x + self.fan_distanceOfLeftView, self.fan_leftViewController.view.center.y);
//            self.fan_leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.fan_proportionOfLeftView, self.fan_proportionOfLeftView);
//        }
//        //        else if(direction==FanSideslipDirectonRight){
//        //            self.fan_leftViewController.view.center = self.fan_rootView.center;
//        //            self.fan_leftViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
//        //        }
//        self.fan_blackCoverView.alpha = direction == FanSideslipDirectionCetenr ? 1 : 0;
//        self.fan_leftViewController.view.alpha = direction == FanSideslipDirectonRight ? 0 : 1;
//        
//    } completion:nil];
//}
//
//-(void)fan_removePanGesture{
//    [self.fan_mainView removeGestureRecognizer:self.fan_panGesture];
//}
//-(void)fan_addPanGesture{
//    [self.fan_mainView addGestureRecognizer:self.fan_panGesture];
//}

@end