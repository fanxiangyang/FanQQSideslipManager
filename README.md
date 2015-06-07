# FanQQSideslipManager
QQSideslip


###  功能介绍
##### 功能介绍：采用类似QQ侧滑效果，封装与一个类中，使用方便，具体使用如下
*   FanLeftViewController *leftVC=[FanLeftViewController new];
*   FanRightViewController *rightVC=[FanRightViewController new];
*   FanTabBarController *tabBarVC=[FanTabBarController new];
*  //核心方法，就这一个方法就可以实现
*   [[FanSideslipManager shareInstance]fan_sideslipInitWithRootView:self.view leftViewcontroller:leftVC rightViewController:rightVC mainViewController:tabBarVC];
*   //辅助功能（一般不需要使用）
*   [FanSideslipManager shareInstance].delegate=self;
*   [FanSideslipManager shareInstance].fan_sideslipDerection=FanSideslipDirectionAll;
###开发环境

* OS X 10.10.3
* Xcode Version 6.3 (6D570)

####有问题请直接在文章下面留言。
####喜欢此系列文章可以点击上面右侧的 Star 哦，变成 Unstar 就可以了！ 


###开发人：凡向阳
####Email:fanxiangyang_heda@163.com


