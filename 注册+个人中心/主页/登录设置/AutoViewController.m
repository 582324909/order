//
//  AutoViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/2.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "AutoViewController.h"

#import "AFNetworking.h"

@interface AutoViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *autoChoose;

@end

@implementation AutoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark-选择是否自动登录
- (IBAction)isOutClick:(id)sender {
    if (!self.autoChoose.isOn) {
        [self cleanData];
    }
}

#pragma mark-清除数据
-(void)cleanData {
    // 沙盒目录操作
    NSString *telPath = [self fileCreate:@"telephone.plist"];
    [self writeFileByDictionary:telPath withObject:@"" andKey:@"telephone"];
    NSString *pwdPath = [self fileCreate:@"password.plist"];
    [self writeFileByDictionary:pwdPath withObject:@"" andKey:@"password"];
}

#pragma mark -文件存储
/**
 * 文件创建 并返回创建的地址
 */
- (NSString *)fileCreate:(NSString *)path {
    // 1.创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 2.获取document路径,括号中属性为当前应用程序独享
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    
    // 3.定义记录文件全名以及路径的字符串filePath
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:path];
    
    // 4.查找文件，如果不存在，就创建一个文件
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    return filePath;
    
}

/**
 * 文件写入 此处是字典类型读取写入
 */
- (void)writeFileByDictionary: (NSString *)filePath withObject:(NSString *)object andKey:(NSString *)key {
    NSDictionary *dict = [NSDictionary dictionaryWithObject:object forKey:key];
    [dict writeToFile:filePath atomically:YES];
}

#pragma mark-注销
- (IBAction)logoutClick:(id)sender {
    [self presentViewController:[self changeController:@"loginViewController" WithStoryboard:@"Main"] animated:YES completion:nil];
}

- (IBAction)test:(id)sender {

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
