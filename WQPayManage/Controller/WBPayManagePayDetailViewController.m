//
//  WBPayManagePayDetailViewController.m
//  WBPayManage
//
//  Created by 杨天宇 on 2018/2/8.
//

#import "WBPayManagePayDetailViewController.h"
#import "WBPayManagePayDetailView.h"
#import <Masonry/Masonry.h>
@interface WBPayManagePayDetailViewController ()<WBPayManagePayDetailViewDelegate>

@property (nonatomic, strong) WBPayManagePayDetailView *basicView;

@end

@implementation WBPayManagePayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self allowInteractivePopGestureRecognizer:NO];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.basicView];
    [self.basicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}

-(WBPayManagePayDetailView *)basicView
{
    if(!_basicView)
    {
        _basicView = [[WBPayManagePayDetailView alloc]init];
        _basicView.delegate = self;
    }
    return _basicView;
}

-(void)WBPayManagePayDetailViewDidClickConfirmButton
{
    [self refreshUserInfo];
}

-(void)refreshUserInfo
{
    [[ZLProgressHUD shared] showText:nil mode:MBProgressHUDModeIndeterminate];
    
    [[WBHttpAPI reloginGetUserInfo]
     .success(^(id obj){
        [[ZLProgressHUD shared] hide:YES];
        
        if ([WBUserManager DefaultManager].userInfo.roles.count) {
            if ([[WBUserManager DefaultManager].userInfo.roles.firstObject.roleCode isEqualToString:@"WXB_WBGR"] ||
                [[WBUserManager DefaultManager].userInfo.roles.firstObject.roleCode isEqualToString:@"WXB_WBGT"]) {
                [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"kWBUserRole"];
            }
            [self requestMenu];
        } else {
            [[[ZLProgressHUD shared] showText:@"该账号下无角色，服务端问题" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
        }
    }).fail(^(HttpError *error){
        [[[ZLProgressHUD shared] showText:error.message mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    })
     sendRequest];
}

- (void)requestMenu {
#ifdef DEBUG
    [[ZLProgressHUD shared] showText:@"正在请求菜单" mode:MBProgressHUDModeIndeterminate];
#endif
    [[WBHttpAPI requestMenuOfRoleId:[WBUserManager DefaultManager].userInfo.roles.firstObject.guid]
     .success(^(id obj){
        [[ZLProgressHUD shared] hide:false];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WBUserLogin" object:nil];
    }).fail(^(HttpError *error){
        [[[ZLProgressHUD shared] showText:error.message mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    })
     sendRequest];
}


@end
