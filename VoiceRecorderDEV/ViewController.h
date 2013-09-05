//
//  ViewController.h
//  VoiceRecorderDEV
//
//  Created by Yang Kai Yu on 9/4/13.
//  Copyright (c) 2013 Yang Kai Yu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface ViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    __weak IBOutlet UIButton *startBtn;
    __weak IBOutlet UIButton *playBtn;
    __weak IBOutlet UIButton *finishBtn;
    __weak IBOutlet UIButton *stopPlayBtn;
     __weak IBOutlet UILabel *status;
    __weak IBOutlet UIProgressView *recordProgressBar;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    NSURL *recordedTmpFile;
    NSMutableDictionary *recordSetting;
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopPlayBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *recordProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *status;

- (IBAction)startRecord:(id)sender;
- (IBAction)finishRecord:(id)sender;
- (IBAction)playAudio:(id)sender;
- (IBAction)stopPlayAudio:(id)sender;

- (void) setRecordConfig;


@end
