//
//  WBPayManageFastOfferViewController.m
//  YunTi-Weibao
//
//  Created by 王强 on 2018/6/5.
//  Copyright © 2018年 浙江再灵科技股份有限公司. All rights reserved.
//

#import "WBPayManageFastOfferViewController.h"
#import "WBPayManageNeedTrackModel.h"
#import <WQRoundedCorner/WQRoundedCorner.h>
#import "WBPayManageFastOfferDatePickerView.h"
#import "WBPayManageNeedTrackViewModel.h"

@interface WBPayManageFastOfferViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *surebutton;//确认按钮
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) WBPayManageNeedTrackViewModel *viewModel;

@end

@implementation WBPayManageFastOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"快速报价";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];
}

//MARK: - surebuttonAction点击事件
- (void)surebuttonAction {
    if (!self.dataModel.priceSum || !self.dataModel.startTime) {
        [[[ZLProgressHUD shared] showText:@"未填写完整" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
    }else{
        WEAKSELF;
        [self.viewModel requestDemandTraceWithRequireId:self.dataModel.requireId feedbackId:self.dataModel.feedbackId pricePerLift:self.dataModel.pricePerLift pricePerTime:self.dataModel.pricePerTime priceSum:self.dataModel.priceSum startTime:self.dataModel.startTime sucessBlock:^(BOOL sucess) {
            if (sucess) {
                if (weakself.DemandTraceSucess) weakself.DemandTraceSucess(YES);
                [[[ZLProgressHUD shared] showText:@"提交成功！" mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
                [weakself.navigationController popViewControllerAnimated:YES];
            }
        } error:^(NSString *errorMessage) {
            [[[ZLProgressHUD shared] showText:errorMessage mode:MBProgressHUDModeText] hide:YES afterDelay:1.5];
        }];
    }
}

//MARK: - 当维保单价和单次维保价格都填写了，才计算总价
-(void)hasFinishFillIn:(NSInteger)pricePerLift pricePerTime:(NSInteger)pricePerTime {
    if(pricePerLift) {
        //单台价格
        self.dataModel.pricePerLift = pricePerLift;
        self.dataModel.pricePerTime = pricePerLift / 24;
    }
    if(pricePerTime) {
        //单次价格
        self.dataModel.pricePerTime = pricePerTime;
        self.dataModel.pricePerLift = pricePerTime * 24;
    }
    if (pricePerLift || pricePerTime) {
        self.dataModel.priceSum = self.dataModel.pricePerLift * self.dataModel.num;
    }
    NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:2 inSection:1];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:3 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath0,indexPath1,indexPath2,nil] withRowAnimation:UITableViewRowAnimationNone];
}

//MARK: - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!section) return 8;
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"WBPayManageFastOfferTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSClassFromString(identifier) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if ([cell respondsToSelector:NSSelectorFromString(@"bindCellModel:indexPath:canEdit:delegate:")]) {
        SEL selector = NSSelectorFromString(@"bindCellModel:indexPath:canEdit:delegate:");
        IMP imp = [cell methodForSelector:selector];
        void (*func)(id, SEL,WBPayManageNeedTrackModel*,NSIndexPath *,BOOL,id) = (void *)imp;
        func(cell, selector,self.dataModel,indexPath,self.canEdit,self);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (!section) return 10;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (!section) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.canEdit && indexPath.section && indexPath.row == 4) {
        //点击了服务开始时间
        WEAKSELF;
        WBPayManageFastOfferDatePickerView *datePicker = [[WBPayManageFastOfferDatePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) clickSure:^(NSString *string) {
            weakself.dataModel.startTime = string;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:1];
            [weakself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        } clickCancel:^{
        }];
        [datePicker startAnimationDatePickerView];
    }
}

/**
 * 开始到结束的时间差 0:在当前时间之前  1：在1年以内  2：1年以外
 */
- (NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 *3600)%3600;
    int day = (int)value / (24 *3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
    }else if (day==0 && house !=0) {
        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
    }else if (day==0 && house==0 && minute!=0) {
        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"耗时%d秒",second];
    }
    return str;
}

//一个时间距现在的时间
- (NSString *)intervalSinceNow: (NSString *) theDate {
    NSArray *timeArray=[theDate componentsSeparatedByString:@"."];
    theDate=[timeArray objectAtIndex:0];

    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];

    NSTimeInterval late=[d timeIntervalSince1970]*1;


    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";

    NSTimeInterval cha=late-now;

    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"剩余%@分", timeString];

    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"剩余%@小时", timeString];
    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"剩余%@天", timeString];

    }
    return timeString;
}

//MARK: - setter / getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WBPayManageScreenWidth, WBPayManageScreenHeight - KNavBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 20, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.tableFooterView = self.canEdit ? self.footerView : [UIView new];
    }
    return _tableView;
}

- (UIButton *)surebutton {
    if (!_surebutton) {
        _surebutton = [UIButton buttonWithType:UIButtonTypeSystem];
        _surebutton.frame = CGRectMake(20, 35, SCREEN_WIDTH - 40, 45);
        [_surebutton setTitle:@"确认" forState:UIControlStateNormal];
        [_surebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _surebutton.titleLabel.font = [UIFont regularPingFangFontOfSize:18];
        [_surebutton setCornerRadius:4 backgroundColor:[UIColor colorWithRed:35/255.0 green:137/255.0 blue:232/255.0 alpha:1]];
        [_surebutton addTarget:self action:@selector(surebuttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _surebutton;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _footerView.backgroundColor = [UIColor whiteColor];
        _footerView.userInteractionEnabled = YES;
        [_footerView addSubview:self.surebutton];
    }
    return _footerView;
}

- (WBPayManageNeedTrackViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[WBPayManageNeedTrackViewModel alloc] init];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
