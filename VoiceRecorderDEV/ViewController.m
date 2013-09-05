//
//  ViewController.m
//  VoiceRecorderDEV
//
//  Created by Yang Kai Yu on 9/4/13.
//  Copyright (c) 2013 Yang Kai Yu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize playBtn = _playBtn;
@synthesize finishBtn = _finishBtn;
@synthesize startBtn = _startBtn;
@synthesize stopPlayBtn = _stopPlayBtn;
@synthesize status = _status;
@synthesize recordProgressBar = _recordProgressBar;
- (void)viewDidLoad
{
    [super viewDidLoad];
	_playBtn.enabled = NO;
    _finishBtn.enabled = NO;
    _stopPlayBtn.enabled = NO;

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;  // 1
    AudioSessionSetProperty (
                             kAudioSessionProperty_OverrideAudioRoute,                         // 2
                             sizeof (audioRouteOverride),                                      // 3
                             &audioRouteOverride                                               // 4
                             );

}

- (IBAction)startRecord:(id)sender {
    [self setRecordConfig];
    NSError *error = nil;
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    [recorder record];
    
    _playBtn.enabled = NO;
    _finishBtn.enabled = YES;
    _startBtn.enabled = NO;
    _status.text = @"Recording.......";
    _recordProgressBar.progress = 0.0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(makeMyProgressBarMoving) userInfo:nil repeats:YES];
}

- (void)makeMyProgressBarMoving {
      
    _recordProgressBar.progress += 0.01;
     NSLog(@"%f", _recordProgressBar.progress);
    if(_recordProgressBar.progress == 1) {
        [recorder stop];
        _playBtn.enabled = YES;
        _status.text = @"Finish Recoding....";
    }
}
    
- (IBAction)finishRecord:(id)sender {
        [self stopTimer];
        [recorder stop];
    if  (_recordProgressBar.progress > 0.2 && _recordProgressBar.progress <= 1) {
        _playBtn.enabled = YES;
        _status.text = @"Finish Recoding....";
    } else {
        _playBtn.enabled = NO;
        _finishBtn.enabled = NO;
        _startBtn.enabled = YES;
        _playBtn.enabled = NO;
        _status.text = @"Status";
        _recordProgressBar.progress = 0.0;
    }
}

- (void) stopTimer {
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (IBAction)playAudio:(id)sender {
    if(!recorder.recording) {
        NSError *error = nil;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedTmpFile error:&error];
        [player prepareToPlay];
        [player play];
        _stopPlayBtn.enabled = YES;
        _startBtn.enabled = NO;
        _finishBtn.enabled = NO;
        _status.text = @"Playing......";
    }
}

- (IBAction)stopPlayAudio:(id)sender {
    [player stop];
    _stopPlayBtn.enabled = NO;
    _startBtn.enabled = YES;
    _finishBtn.enabled = YES;
      _status.text = @"Stop Playing......";

}

- (void) setRecordConfig {
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sound.caf"];
    
    recordSetting= [NSDictionary
                    dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:AVAudioQualityMin],
                    AVEncoderAudioQualityKey,
                    [NSNumber numberWithInt:16],
                    AVEncoderBitRateKey,
                    [NSNumber numberWithInt: 2],
                    AVNumberOfChannelsKey,
                    [NSNumber numberWithFloat:44100.0],
                    AVSampleRateKey,
                    nil];
    recordedTmpFile = [NSURL fileURLWithPath:soundFilePath];
}

@end
