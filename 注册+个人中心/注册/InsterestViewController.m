//
//  InsterestViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/4.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "InsterestViewController.h"
#import "AppDelegate.h"

@interface InsterestViewController ()

@property (nonatomic,strong) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation InsterestViewController

- (void)viewDidLoad {
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [super viewDidLoad];
}

- (IBAction)click:(id)sender {
    if (self.btn.selected == NO) {
        self.appDelegate.insterest = self.btn.titleLabel.text;
        self.btn.selected = YES;
    }else if (self.btn.selected == YES) {
        self.appDelegate.insterest = @"未选择兴趣";
        self.btn.selected = NO;
    }
}

- (IBAction)continueClick:(id)sender {
    [self presentViewController:[self changeController:@"nickName" WithStoryboard:@"Main"] animated:YES completion:nil];
}

//自定义界面跳转方法
-(UIViewController *)changeController:(NSString *)controllerIdentifier WithStoryboard:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    return controller;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
