//
//  LoginViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/1.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "URLHead.h"

#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()

@property (nonatomic,strong) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UITextField *telephoneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [super viewDidLoad];
}

#pragma mark-登录按钮
- (IBAction)loginClick:(id)sender {
    if (self.telephoneField.text.length == 0 || self.passwordField.text.length == 0) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名和密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
    }else {
        [self checkLoginInfo];
    }
}

- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-跳转到注册界面
- (IBAction)registClick:(id)sender {
    [self presentViewController:[self changeController:@"regist" WithStoryboard:@"Main"] animated:YES completion:nil];
}

#pragma mark-核实登录信息
-(void)checkLoginInfo {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"telephone"] = self.telephoneField.text;
    parameter[@"password"] = self.passwordField.text;
    
    [httpSession POST:loginURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
            
            NSLog(@"%@",dic);
            self.appDelegate.nickname = dic[@"info"][@"user_nickname"];
            self.appDelegate.insterest = dic[@"info"][@"insterest"];
            self.appDelegate.user_id = [dic[@"info"][@"user_id"] intValue];
            self.appDelegate.header_url = dic[@"info"][@"header_url"];
            
            // 沙盒目录操作
            NSString *telPath = [self fileCreate:@"telephone.plist"];
            [self writeFileByDictionary:telPath withObject:self.telephoneField.text andKey:@"telephone"];
            NSString *pwdPath = [self fileCreate:@"password.plist"];
            [self writeFileByDictionary:pwdPath withObject:self.passwordField.text andKey:@"password"];
            
            [self presentViewController:[self changeController:@"home" WithStoryboard:@"Info"] animated:YES completion:nil];
            
        }else if ([dic[@"code"] intValue] == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名密码不匹配" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }else if ([dic[@"code"] intValue] == 2){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不存在" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    
//    [httpSession POST:loginURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        if ([dic[@"code"] intValue] == 0) {
//            
//            NSLog(@"%@",dic);
//            self.appDelegate.nickname = dic[@"info"][@"user_nickname"];
//            self.appDelegate.insterest = dic[@"info"][@"insterest"];
//            self.appDelegate.user_id = [dic[@"info"][@"user_id"] intValue];
//            
//            // 沙盒目录操作
//            NSString *telPath = [self fileCreate:@"telephone.plist"];
//            [self writeFileByDictionary:telPath withObject:self.telephoneField.text andKey:@"telephone"];
//            NSString *pwdPath = [self fileCreate:@"password.plist"];
//            [self writeFileByDictionary:pwdPath withObject:self.passwordField.text andKey:@"password"];
//            
//            [self presentViewController:[self changeController:@"home" WithStoryboard:@"Info"] animated:YES completion:nil];
//            
//        }else if ([dic[@"code"] intValue] == 1){
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名密码不匹配" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alertView show];
//        }else if ([dic[@"code"] intValue] == 2){
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不存在" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alertView show];
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];
//    }];
    
}

//自定义界面跳转方法
-(UIViewController *)changeController:(NSString *)controllerIdentifier WithStoryboard:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    return controller;
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.telephoneField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
