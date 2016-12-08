//
//  PasswordViewController.m
//  注册+个人中心
//
//  Created by 张伟伟 on 16/8/1.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "PasswordViewController.h"
#import "AppDelegate.h"
#import "URLHead.h"

#import "AFNetworking.h"

@interface PasswordViewController ()

@property (nonatomic,strong) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (weak, nonatomic) IBOutlet UITextField *password2;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [super viewDidLoad];
}

#pragma mark-继续按钮点击事件
- (IBAction)continueClick:(id)sender {
    if (self.password1.text.length < 5) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不合法" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }else if (![self.password1.text isEqualToString:self.password2.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }else {
        self.appDelegate.password = self.password2.text;
        [self presentViewController:[self changeController:@"insterest" WithStoryboard:@"Main"] animated:YES completion:nil];
    }
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

//自定义界面跳转方法
-(UIViewController *)changeController:(NSString *)controllerIdentifier WithStoryboard:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    return controller;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.password1 resignFirstResponder];
    [self.password2 resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
