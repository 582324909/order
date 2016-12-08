//
//  ViewController.m
//  注册+个人中心
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

#import "AppDelegate.h"
#import "URLHead.h"

#define ImageCount 2

static NSString *login_telephone;
static NSString *login_password;


@interface ViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (nonatomic,strong) AppDelegate *appDelegate;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,weak) UIPageControl *pageControl;
@property (nonatomic, weak) CALayer *layer;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong)UIView *cover;

@end


@implementation ViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self scrollView];
    [self addCover];
    [self addLoginBtn];
    self.myScrollView.userInteractionEnabled = NO;
    [self addTimer];
    [self addDelayTime];
    
    NSString *telephone = [self fileCreate:@"telephone.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:telephone];
    login_telephone = dict[@"telephone"];
    
    NSString *password = [self fileCreate:@"password.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:password];
    login_password = dic[@"password"];
    
    
}

- (void)scrollView{
    self.myScrollView.delegate = self;
    for (int i = 1; i <= ImageCount; i++ ) {
        CGFloat imageViewX = 0;
        CGFloat imageViewY = (i - 1)  * self.view.bounds.size.height;
        CGFloat imageViewW = self.view.bounds.size.width;
        CGFloat imageViewH = self.view.bounds.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
        NSString *imageName = [NSString stringWithFormat:@"back%d",i];
        myImageView.image = [UIImage imageNamed:imageName];
        [self.myScrollView addSubview:myImageView];
        
    }
    self.myScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, ImageCount * self.view.bounds.size.height);
    
    
}

- (void)addDelayTime{
    [self performSelector:@selector(addTimer2) withObject:nil afterDelay:20.0f];
    for (int i = 1; i <= 1000; i++) {
        int time = 40.0 *i;
        [self performSelector:@selector(addTimer2) withObject:nil afterDelay:20.0f + time];
    }
    
}
- (void)addTimer {
    CGPoint bottomOffset = CGPointMake(0, self.view.bounds.size.height *0.25);
    
    //设置延迟时间
    float scrollDurationInSeconds = 20.0;
    
    float totalScrollAmount = bottomOffset.y;
    float timerInterval = scrollDurationInSeconds / totalScrollAmount;
    [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(cycleImage:) userInfo:nil repeats:YES];
    
}

- (void)addTimer2 {
    CGPoint bottomOffset = CGPointMake(0, self.view.bounds.size.height *0.25);
    
    //设置延迟时间
    float scrollDurationInSeconds = 20.0;
    
    float totalScrollAmount = bottomOffset.y;
    float timerInterval = scrollDurationInSeconds / totalScrollAmount;
    [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(cycleImage2:) userInfo:nil repeats:YES];
}

- (void)cycleImage:(NSTimer *)timer{
    
    CGPoint newScrollViewContentOffset = self.myScrollView.contentOffset;
    
    newScrollViewContentOffset.y += 1;
    
    self.myScrollView.contentOffset = newScrollViewContentOffset;
    
    if (newScrollViewContentOffset.y == self.view.frame.size.height*0.25) {
        [timer invalidate];
        
    }
    
}

- (void)cycleImage2:(NSTimer *)timer{
    CGPoint newScrollViewContentOffset= self.myScrollView.contentOffset;
    
    newScrollViewContentOffset.y -= 1;
    //[timer fire];
    self.myScrollView.contentOffset = newScrollViewContentOffset;
    if (newScrollViewContentOffset.y == 0) {
        [timer invalidate];
        [self addTimer];
        
    }
    
}

#pragma mark-添加遮罩层
- (void)addCover{
    UIView *cover = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.myScrollView.contentSize.height)];
    self.cover = cover;
    cover.alpha = 0.4;
    cover.backgroundColor = [UIColor blackColor];
    [self.myScrollView addSubview:cover];
    
}

#pragma mark-代码添加控件
- (void)addLoginBtn{
    CGFloat btnX = self.view.bounds.size.width * 0.2;
    CGFloat btnY = self.view.bounds.size.height * 0.6;
    CGFloat btnW = self.view.bounds.size.width * 0.6;
    CGFloat btnH = self.view.bounds.size.width * 0.1;
    
    UIButton *registBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY + 40, btnW, btnH)];
    registBtn.backgroundColor = [UIColor whiteColor];
    registBtn.alpha = 0.3;
    registBtn.layer.cornerRadius = 7.0;
    [self.view addSubview:registBtn];
    
    UIView *RegistBtnView = [[UIView alloc]initWithFrame:CGRectMake(btnX, btnY + 40, btnW, btnH)];
    [RegistBtnView setBackgroundColor:[UIColor clearColor]];
    [registBtn addSubview:RegistBtnView];
    
    UIButton *RegistBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY + 40, btnW, btnH)];
    RegistBtn.backgroundColor = [UIColor clearColor];
    [RegistBtn setTitle:@"开始体验" forState:UIControlStateNormal];
    [RegistBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RegistBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [RegistBtn addTarget:self action:@selector(welcome) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RegistBtn];
    
}

#pragma mark-注册的点击事件
- (void)welcome{
    if (login_password.length > 1) {
        [self checkLoginInfo];
    }else {
        [self performSegueWithIdentifier:@"regist" sender:nil];
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

#pragma mark-核实登录信息
-(void)checkLoginInfo {
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    parameter[@"telephone"] = login_telephone;
    parameter[@"password"] = login_password;
    
    [httpSession POST:loginURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([dic[@"code"] intValue] == 0) {
            self.appDelegate.nickname = dic[@"info"][@"user_nickname"];
            self.appDelegate.insterest = dic[@"info"][@"insterest"];
            self.appDelegate.user_id = [dic[@"info"][@"user_id"] intValue];
            self.appDelegate.header_url = dic[@"info"][@"header_url"];
            
            [self presentViewController:[self changeController:@"home" WithStoryboard:@"Info"] animated:YES completion:nil];
            
        }else {
            [self presentViewController:[self changeController:@"loginViewController" WithStoryboard:@"Main"] animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"链接服务器失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    
//    [httpSession POST:loginURL parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        if ([dic[@"code"] intValue] == 0) {
//            self.appDelegate.nickname = dic[@"info"][@"user_nickname"];
//            self.appDelegate.insterest = dic[@"info"][@"insterest"];
//            self.appDelegate.user_id = [dic[@"info"][@"user_id"] intValue];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
