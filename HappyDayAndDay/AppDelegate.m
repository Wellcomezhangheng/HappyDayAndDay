//
//  AppDelegate.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "AppDelegate.h"
#import "mainViewController.h"
#import "discoverViewController.h"
#import "mineViewController.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//UITabBarController
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
//创建被tabBarVC管理的视图控制器
    //主页
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"mainStoryboard" bundle:nil];
    UINavigationController *mainNVC = mainStoryboard.instantiateInitialViewController;
//    mainNVC.tabBarItem.title = @"首页";
    mainNVC.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic.png"];
    UIImage *mainImage = [UIImage imageNamed:@"ft_home_selected_ic.png"];
    //tabBar设置选中图片按照图片原始状态显示
    mainNVC.tabBarItem.selectedImage = [mainImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
  mainNVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //发现
    UIStoryboard *discoverStoryboard = [UIStoryboard storyboardWithName:@"discoverStoryboard" bundle:nil];
    UINavigationController *discoverNVC = discoverStoryboard.instantiateInitialViewController;
    //discoverNVC.tabBarItem.title = @"首页";
    discoverNVC.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic.png"];
    UIImage *discoverImage = [UIImage imageNamed:@"ft_found_selected_ic.png"];
    //tabBar设置选中图片按照图片原始状态显示
    discoverNVC.tabBarItem.selectedImage = [discoverImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    discoverNVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //我的ft_found_selected_ic.png
    UIStoryboard *mineStoryboard = [UIStoryboard storyboardWithName:@"mineStoryboard" bundle:nil];
    UINavigationController *mineNVC = mineStoryboard.instantiateInitialViewController;
   // mineNVC.tabBarItem.title = @"首页";
    mineNVC.tabBarItem.image = [UIImage imageNamed:@"ft_person_normal_ic.png"];UIImage *mineImage = [UIImage imageNamed:@"ft_person_selected_ic.png"];
    //tabBar设置选中图片按照图片原始状态显示
    mineNVC.tabBarItem.selectedImage = [mineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //按照上左下右的方法去设置
    mineNVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    
    
    //添加被管理的视图控制器
    tabBarVC.viewControllers = @[mainNVC,discoverNVC,mineNVC];
    self.window.rootViewController = tabBarVC;
    tabBarVC.tabBar.barTintColor = [UIColor whiteColor];
    //选中颜色
    tabBarVC.tabBar.tintColor=[UIColor cyanColor];
    
    
    
    
    
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
