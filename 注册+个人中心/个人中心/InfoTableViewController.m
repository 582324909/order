//
//  InfoTableViewController.m
//  个人中心
//
//  Created by 张伟伟 on 16/7/28.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "InfoTableViewController.h"
#import "HFStretchableTableHeaderView.h"
#import "AppDelegate.h"
#import "URLHead.h"
#import "UINavigationBar+Awesome.h"

#import "UIImageView+WebCache.h"
#import "AFNetworking.h"

#define NAVBAR_CHANGE_POINT 50
#define StretchHeaderHeight 300

@interface InfoTableViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UILabel *nickname;
@property (nonatomic,strong) AppDelegate *appDelegate;
@property (nonatomic,strong)HFStretchableTableHeaderView *stretchHeaderView;

@end

@implementation InfoTableViewController

-(void)viewWillAppear:(BOOL)animated {
    UILabel *name = (UILabel *)[self.view viewWithTag:601];
    if (self.appDelegate.nickname.length > 0) {
        name.text = self.appDelegate.nickname;
    }
    [super viewWillAppear:YES];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.nickname.text = self.appDelegate.nickname;
    [self initStretchHeader];

    self.tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)initStretchHeader
{
    //背景
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, StretchHeaderHeight)];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    bgImageView.clipsToBounds = YES;
    bgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"backgroundimage" ofType:@"jpg"]];
    
    //背景之上的内容
    UIView *contentView = [[UIView alloc] initWithFrame:bgImageView.bounds];
    contentView.backgroundColor = [UIColor clearColor];

    UIImageView *avater = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    [avater setTag:501];
    avater.layer.cornerRadius = 45;
    avater.layer.masksToBounds = YES;
    avater.userInteractionEnabled = YES;
    if (self.appDelegate.header_url != nil) {
        NSURL *url = [NSURL URLWithString:self.appDelegate.header_url];
        [avater sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headimage_default"]];
    }else {
        avater.image = [UIImage imageNamed:@"headimage_default"];
    }
    CGPoint p = CGPointMake(contentView.center.x, contentView.center.y + 50);
    avater.center = p;
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage)];
    [avater addGestureRecognizer:click];
    [contentView addSubview:avater];

    self.nickname = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [self.nickname setTag:601];
    self.nickname.textAlignment = NSTextAlignmentCenter;
    self.nickname.textColor = [UIColor whiteColor];
    CGPoint n = CGPointMake(avater.center.x, avater.center.y + 55);
    self.nickname.center = n;
    [contentView addSubview:self.nickname];
    
    self.stretchHeaderView = [HFStretchableTableHeaderView new];
    [self.stretchHeaderView stretchHeaderForTableView:self.tableView withView:bgImageView subViews:contentView];
}

-(void)clickImage {
        UIActionSheet *choose = [[UIActionSheet alloc] initWithTitle:@"选取图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
        [choose showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%ld",buttonIndex);
    
    if (buttonIndex == 0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else if (buttonIndex == 1){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView *imageview = (UIImageView *)[self.view viewWithTag:501];
    imageview.image = image;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:uploadURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image,0.1);
        [formData appendPartWithFileData:imageData name:@"user_header_image" fileName:@"image.png" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject) {
            NSLog(@"%@",responseObject[@"message"]);
            self.appDelegate.header_url = responseObject[@"message"];
            [self saveURLWithURL:responseObject[@"message"]];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveURLWithURL:(NSString *)url {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"userid"] = [NSString stringWithFormat:@"%d",self.appDelegate.user_id];
    parameter[@"header"] = url;
    
    [httpSession POST:modifyHeaderURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

#pragma mark - stretchableTable delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.stretchHeaderView scrollViewDidScroll:scrollView];
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        //self.navigationItem.titleView.hidden = NO;
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        //self.navigationItem.titleView.hidden = YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
