//
//  SourceInputViewController.m
//  CicadaPlayerDemo
//
//  Created by 郦立 on 2018/12/29.
//  Copyright © 2018年 com.alibaba. All rights reserved.
//

#import "SourceInputViewController.h"
#import "CicadaPlayerViewController.h"
#import "CicadaScanViewController.h"

@interface SourceInputViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *URLTextField;

@end

@implementation SourceInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     "https://cocoplayer.oss-cn-chengdu.aliyuncs.com/videos/DemonicKing/DemonicKing1min_240p.mp4",
     "https://cocoplayer.oss-cn-chengdu.aliyuncs.com/videos/DemonicKing/Demonic-King-0-60.mp4",
     "https://cocoplayer.oss-cn-chengdu.aliyuncs.com/videos/DemonicKing/Demonic-King-520-560.mp4",
     "https://cocoplayer.oss-cn-chengdu.aliyuncs.com/videos/h264-dash/WeBareBears.mpd",
     "https://cocoplayer.oss-cn-chengdu.aliyuncs.com/videos/LiYongLe/H264/dash/LiYongLe-h264.mpd",
     "https://cocoplayer.oss-cn-chengdu.aliyuncs.com/videos/LiYongLe/LYL_general_short240p.mp4",
     "https://cocoplayer.oss-cn-chengdu.aliyuncs.com/videos/LR/demoLYL_LR.mp4",
     "https://cocoplayer.oss-cn-chengdu.aliyuncs.com/videos/Math-Problem/TheSimplestMathProblem_2min.mp4",
     "https://cocoplayer.oss-cn-chengdu.aliyuncs.com/videos/Trailers/Be-My-Princess-240p.mp4",
     "https://cocoplayer.oss-cn-chengdu.aliyuncs.com/videos/Trailers/Ming-Ji-240p.mp4",
     "https://cocoplayer.oss-cn-chengdu.aliyuncs.com/videos/Trailers/San-Sheng-You-Xing-Yu-Shang-Ni-240p.mp4",
     "https://cocoplayer.oss-cn-chengdu.aliyuncs.com/videos/Trailers/Yi-Sheng-Yi-Shi-240p.mp4",
     "https://cocoplayer.oss-cn-chengdu.aliyuncs.com/videos/vp9-dash/LastWeekTonight.mpd"
     
     "https://dash.akamaized.net/dash264/TestCasesHD/1b/qualcomm/1/MultiRate.mpd",
    "https://dash.akamaized.net/dash264/TestCasesHD/1b/qualcomm/2/MultiRate.mpd",
    "https://dash.akamaized.net/dash264/TestCasesHD/2b/qualcomm/1/MultiResMPEG2.mpd",
    "https://dash.akamaized.net/dash264/TestCasesHD/2b/qualcomm/2/MultiRes.mpd",
    "https://dash.akamaized.net/dash264/TestCases/1b/qualcomm/1/MultiRatePatched.mpd",
    "https://dash.akamaized.net/dash264/TestCases/1b/qualcomm/2/MultiRate.mpd",
    "https://dash.akamaized.net/dash264/TestCases/2b/qualcomm/1/MultiResMPEG2.mpd",
    "https://dash.akamaized.net/dash264/TestCases/2b/qualcomm/2/MultiRes.mpd",
    "https://dash.akamaized.net/dash264/TestCases/9b/qualcomm/1/MultiRate.mpd",
    "https://dash.akamaized.net/dash264/TestCases/9b/qualcomm/2/MultiRate.mpd",
     */
    
    self.URLTextField.text = @"https://cocoplayer.oss-cn-chengdu.aliyuncs.com/videos/DemonicKing/DemonicKing1min_240p.mp4";
    
    // 开发测试用
//    self.URLTextField.text = @"http://player.alicdn.com/video/aliyunmedia.mp4";
    
//    // 苹果官方测试视频
//    self.URLTextField.text = @"https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8";
//
//    // 有多视频轨，没有音频轨、字幕轨
//    self.URLTextField.text = @"https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8";
}

/**
 进入URL播放

 @param sender 调用者
 */
- (IBAction)gotoURLPlay:(id)sender {
    if (self.isClickedFlag == NO) {
        self.isClickedFlag = YES;
        NSString *urlStr = self.URLTextField.text;
        CicadaUrlSource *source = [[CicadaUrlSource alloc] urlWithString:urlStr];
        CicadaPlayerViewController *vc = [[CicadaPlayerViewController alloc]init];
        vc.urlSource = source;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)pushToScan:(id)sender {
    if (self.isClickedFlag == NO) {
        self.isClickedFlag = YES;
        CicadaScanViewController *vc = [[CicadaScanViewController alloc]init];
        vc.scanTextCallBack = ^(NSString *text) {
            self.URLTextField.text = text;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark textDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end








