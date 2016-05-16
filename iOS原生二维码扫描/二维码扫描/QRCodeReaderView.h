//
//  QRCodeReaderView.h
//  YiBang
//
//  Created by 时双齐 on 15/12/31.
//  Copyright © 2015年 时双齐. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QRCodeReaderViewDelegate <NSObject>
- (void)readerScanResult:(NSString *)result;
@end

@interface QRCodeReaderView : UIView

@property (nonatomic, weak) id<QRCodeReaderViewDelegate> delegate;
@property (nonatomic,copy)UIImageView * readLineView;
@property (nonatomic,assign)BOOL is_Anmotion;
@property (nonatomic,assign)BOOL is_AnmotionFinished;

//开启关闭扫描
- (void)start;
- (void)stop;

- (void)loopDrawLine;//初始化扫描线

@end
