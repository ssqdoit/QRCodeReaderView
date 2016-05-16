//
//  ViewController.m
//  iOS原生二维码扫描
//
//  Created by 时双齐 on 16/5/16.
//  Copyright © 2016年 MoreCookies. All rights reserved.
//
#import "QRCodeReaderView.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/320
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)

#import "ViewController.h"

@interface ViewController ()<QRCodeReaderViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    QRCodeReaderView * readview;//二维码扫描对象
    
    BOOL isFirst;//第一次进入该页面
    BOOL isPush;//跳转到下一级页面
}

@property (strong, nonatomic) CIDetector *detector;
@property (weak, nonatomic) IBOutlet UIImageView *scanCropView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"扫描";
    self.view.backgroundColor = [UIColor whiteColor];
    
    isFirst = YES;
    isPush = NO;
    
    //扫描区域
    UIImage *hbImage=[UIImage imageNamed:@"icon_shouji"];
    UIImageView * scanCropView=[[UIImageView alloc] init];
    scanCropView.backgroundColor = [UIColor clearColor];
    scanCropView.layer.borderColor = [UIColor whiteColor].CGColor;
    scanCropView.layer.borderWidth = 2.5;
    scanCropView.image = hbImage;
    //添加一个背景图片
    CGRect mImagerect = CGRectMake(60*widthRate, (DeviceMaxHeight-200*widthRate)/2, 200*widthRate, 200*widthRate);
    [scanCropView setFrame:mImagerect];
    self.scanCropView = scanCropView;
    self.scanCropView.userInteractionEnabled = YES;
    [self.view addSubview:self.scanCropView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClicked)];
    
    [self.scanCropView addGestureRecognizer:tap];
    
    //用于说明的label
    UILabel * labIntroudction= [[UILabel alloc] init];
    CGFloat heih = (DeviceMaxHeight-200*widthRate)/2;
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(0, 64+(heih-64-50*widthRate)/2, DeviceMaxWidth, 50*widthRate);
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor blackColor];
    labIntroudction.text=@"将二维码放入框中，即自动扫描";
    [self.view addSubview:labIntroudction];
}

-(void)tapClicked
{
    [self InitScan];
}

#pragma mark 初始化扫描
- (void)InitScan
{
    if (readview) {
        [readview removeFromSuperview];
        readview = nil;
    }
    
    readview = [[QRCodeReaderView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight - 64)];
    readview.is_AnmotionFinished = YES;
    [readview loopDrawLine];
    readview.backgroundColor = [UIColor clearColor];
    readview.delegate = self;
    readview.alpha = 0;
    
    [self.view addSubview:readview];
    
    [UIView animateWithDuration:0.5 animations:^{
        readview.alpha = 1;
    }completion:^(BOOL finished) {
        
    }];
    
}


#pragma mark -QRCodeReaderViewDelegate
- (void)readerScanResult:(NSString *)result
{
    readview.is_Anmotion = YES;
    [readview stop];
    
    //播放扫描二维码的声音
    SystemSoundID soundID;
    NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
    if (strSoundFile) {
        AudioServicesCreateSystemSoundID((__bridge  CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
    }
    AudioServicesPlaySystemSound(soundID);
    
    [self accordingQcode:result];
}

#pragma mark - 扫描结果处理
- (void)accordingQcode:(NSString *)str
{
    //扫描结果处理
    //code
}

- (void)reStartScan
{
    readview.is_Anmotion = NO;
    
    if (readview.is_AnmotionFinished) {
        [readview loopDrawLine];
    }
    
    [readview start];
}

#pragma mark - view
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isFirst || isPush) {
        if (readview) {
            [self reStartScan];
        }
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (readview) {
        [readview stop];
        readview.is_Anmotion = YES;
    }
    
    [readview removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (isFirst) {
        isFirst = NO;
    }
    if (isPush) {
        isPush = NO;
    }
    
}

@end
