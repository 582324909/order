//
//  AppDelegate.h
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/1.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,copy) NSIndexPath *isChoose;

@property (nonatomic, assign) int user_id;
@property (nonatomic, assign) int classVc;
@property (nonatomic, assign) int indexOfCell;

@property (nonatomic, copy) NSString *shop_id;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *insterest;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *header_url;

@property (nonatomic, strong) NSArray *orderResultArray;

+ (instancetype)shareAppDelegate;

@end

