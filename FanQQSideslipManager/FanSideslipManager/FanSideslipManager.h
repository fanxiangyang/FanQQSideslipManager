//
//  FanSideslipManager.h
//  QQSlide
//
//  Created by 向阳凡 on 15/6/6.
//  Copyright (c) 2015年 向阳凡. All rights reserved.
//



/** 类似QQ的侧滑
 
 *介绍： 本侧滑用单例类封装，可以传人任意你想传的RootView上面，甚至是Window，使用及其简单，只有一个函数就可以搞定
        其中添加与移除手势是为了实现只在主界面侧滑，二级push页面关闭侧滑使用
 *用法： FanLeftViewController *leftVC=[FanLeftViewController new];
        FanTabBarController *tabBarVC=[FanTabBarController new];
        [[FanSideslipManager shareInstance]fan_sideslipInitWithRootView:self.view leftViewcontroller:leftVC tabBarController:tabBarVC];
 *手势：-(void)viewDidAppear:(BOOL)animated{
            [super viewDidAppear:animated];
            [[FanSideslipManager shareInstance] fan_addPanGesture];
        }
        -(void)viewWillDisappear:(BOOL)animated{
            [super viewWillDisappear:animated];
            [[FanSideslipManager shareInstance] fan_removePanGesture];
        }
 *
 *注意： 1.fan_fullDistance要大于fan_proportion，且设置比例最好大于0.6，建议在0.7以上
        2.
 *
 *
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kFanScreenWidth ([UIScreen mainScreen].applicationFrame.size.width)
#define kFanScreenHeight ([UIScreen mainScreen].applicationFrame.size.height)
//#define kFanScreenWidth ([UIScreen mainScreen].bounds.size.width)
//#define kFanScreenHeight ([UIScreen mainScreen].bounds.size.height)


typedef NS_ENUM(NSInteger, FanSideslipDirection) {
    FanSideslipDirectionLeft = 0,
    FanSideslipDirectonRight,
    FanSideslipDirectionCetenr
};


@interface FanSideslipManager : NSObject<UIGestureRecognizerDelegate>

#pragma mark - 外界传过来的视图及view
/** 侧滑的底view */
@property(nonatomic,strong)UIView *fan_rootView;
/** 左视图控制器 */
@property(nonatomic,strong)UIViewController *fan_leftViewController;
/** 基于tabBar的视图控制器 */
@property(nonatomic,strong)UITabBarController *fan_tabBarController;



#pragma mark - 可选修改的属性
/** 左视图偏移量，默认0  可以为负 */
@property(nonatomic,assign)CGFloat fan_leftOffSet;
/** 右视图偏移量，默认0 可以为负 */
@property(nonatomic,assign)CGFloat fan_rightOffSet;
/** 中心视图缩放比例最小值,默认0.77 */
@property(nonatomic,assign)CGFloat fan_proportion;
/** 满屏视图缩放比例最小值,默认0.78 */
@property(nonatomic,assign)CGFloat fan_fullDistance;
/** 左视图缩放比例显示时,默认1.0 */
@property(nonatomic,assign)CGFloat fan_proportionOfLeftView;



#pragma mark - 内部使用属性（最好不要修改）
/** 底部的view，所有view都在他上面 */
@property(nonatomic,strong)UIView *fan_mainView;
/** 背景黑色遮盖层，增强视觉效果 */
@property(nonatomic,strong)UIView *fan_blackCoverView;
/** 滑动的实时距离,默认0.0 */
@property(nonatomic,assign)CGFloat fan_distance;
/** 左视图中心坐标 */
@property(nonatomic,assign)CGPoint fan_centerOfLeftViewAtBeginning;
/** 左视图偏移量，默认通过fan_fullDistance的缩放比例计算 */
@property(nonatomic,assign)CGFloat fan_distanceOfLeftView;
/** 单击手势 */
@property(nonatomic,strong)UITapGestureRecognizer *fan_tapGesture;
/** 侧滑手势 */
@property(nonatomic,strong)UIPanGestureRecognizer *fan_panGesture;



#pragma mark - FanSideslipManager方法
//MARK:- 单例
/** 侧滑手势的单例 */
+(FanSideslipManager *)shareInstance;
//MARK:- 实现侧滑的初始化方法
/** 移除侧滑手势 */
-(void)fan_sideslipInitWithRootView:(UIView *)rootView leftViewcontroller:(UIViewController *)leftViewController tabBarController:(UITabBarController *)tabBarController;
/** 移除侧滑手势 */
-(void)fan_removePanGesture;
/** 添加侧滑手势 */
-(void)fan_addPanGesture;
//MARK:- 外部按钮控制侧滑
/** 展示左视图 */
-(void)fan_showLeft;
/** 展示右视图 */
-(void)fan_showRight;
/** 展示主视图 */
-(void)fan_showHome;
@end
