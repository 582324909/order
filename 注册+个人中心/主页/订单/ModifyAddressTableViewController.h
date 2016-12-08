//
//  ModifyAddressTableViewController.h
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/5.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString * (^NameBlock)();
typedef NSString * (^SexBlock)();
typedef NSString * (^ShopNameBlock)();
typedef NSString * (^AddressBlock)();
typedef NSString * (^TelephoneBlock)();

@interface ModifyAddressTableViewController : UITableViewController

@property (nonatomic, copy) NameBlock nameBlock;
@property (nonatomic, copy) SexBlock sexBlock;
@property (nonatomic, copy) ShopNameBlock shopNameBlock;
@property (nonatomic, copy) AddressBlock addressBlock;
@property (nonatomic, copy) TelephoneBlock telephoneBlock;

@end
