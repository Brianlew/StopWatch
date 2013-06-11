//
//  ViewController.m
//  Stopwatch
//
//  Created by Brian Lewis on 5/3/13.
//  Copyright (c) 2013 Brian Lewis. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    __weak IBOutlet UILabel *totalTime;
   
    __weak IBOutlet UILabel *lapName;
    __weak IBOutlet UILabel *lapTime;
    
    __weak IBOutlet UILabel *lastLapName;
    __weak IBOutlet UILabel *lastLapTime;
    
    __weak IBOutlet UILabel *secondToLastLapName;
    __weak IBOutlet UILabel *secondToLastLapTime;
    
    __weak IBOutlet UIButton *startLapButtonLabel;
    
    int totalTimeInMilliseconds;
    int millisecondsSinceStartOfCurrentLap;
    int seconds;
    int minutes;
    int lapCount;
        
    NSTimer *timer;
}

- (IBAction)startLapButton:(id)sender;
- (IBAction)pauseButton:(id)sender;
- (IBAction)stopButton:(id)sender;

-(void)upDateCurrentTime: (NSTimer *)t;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [startLapButtonLabel setTitle:@"Start" forState:UIControlStateNormal];
    
    lapTime.text = @"";
    lastLapTime.text = @"";
    secondToLastLapTime.text = @"";
    lapName.text = @"";
    lastLapName.text = @"";
    secondToLastLapName.text = @"";

    lapCount = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)upDateCurrentTime:(NSTimer *)t
{
    //updateCurrentTime gets called every 10 milliseconds
    //update timer of current lap
    millisecondsSinceStartOfCurrentLap += 10;
    seconds = millisecondsSinceStartOfCurrentLap/100;
    minutes = seconds/60;
    
    lapTime.text = [NSString stringWithFormat:@"%02d:%02d.%i",minutes, seconds%60, (millisecondsSinceStartOfCurrentLap/10)%10];
    
    //update total timer
    totalTimeInMilliseconds += 10;
    seconds = totalTimeInMilliseconds/100;
    minutes = seconds/60;
    
    totalTime.text = [NSString stringWithFormat:@"%02d:%02d.%i",minutes, seconds%60, (totalTimeInMilliseconds/10)%10];
}

- (IBAction)startLapButton:(id)sender {
    
    //if the timer is not currenly running
    if(![startLapButtonLabel.titleLabel.text isEqual: @"Lap"])
    {        
        timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(upDateCurrentTime:) userInfo:nil repeats:YES];
        
        //if the start button was hit for the first time, put the 1st lap on the screen when the timer starts
        if([startLapButtonLabel.titleLabel.text isEqual:@"Start"])
        {
            lapName.text = [NSString stringWithFormat:@"Lap %i: ", lapCount];
        }
    
        [startLapButtonLabel setTitle:@"Lap" forState:UIControlStateNormal];
    }
    
    //user hits lap button to record the lap
    else { 
        lapCount++;
        
        //the last 3 laps are shown on screen if we are at least on our third lap
        if(lapCount >= 3){ 
            secondToLastLapName.text = [NSString stringWithFormat:@"Lap %i: ", lapCount-2];
            secondToLastLapTime.text = [NSString stringWithFormat:@"%@", lastLapTime.text];;
            lastLapName.text = [NSString stringWithFormat:@"Lap %i: ", lapCount-1];
            lastLapTime.text = [NSString stringWithFormat:@"%@", lapTime.text];;
            lapName.text = [NSString stringWithFormat:@"Lap %i: ", lapCount];
            lapTime.text = [NSString stringWithFormat:@"%@", totalTime.text];
        }
        //laps 1 and 2 are on screen if we are on our second lap
        if(lapCount == 2){
            lastLapName.text = [NSString stringWithFormat:@"Lap %i: ", lapCount-1];
            lastLapTime.text = [NSString stringWithFormat:@"%@", lapTime.text];;
            lapName.text = [NSString stringWithFormat:@"Lap %i: ", lapCount];
            lapTime.text = [NSString stringWithFormat:@"%@", totalTime.text];
        }
           
        //current lap time goes back to 0
        millisecondsSinceStartOfCurrentLap = 0;
    }
}

- (IBAction)pauseButton:(id)sender {
    
    //if the timer is currently running
    if([startLapButtonLabel.titleLabel.text isEqual: @"Lap"])
    {
        //stop the timer and set the start/lap button text to Resume
        [timer invalidate];
    
        [startLapButtonLabel setTitle:@"Resume" forState:UIControlStateNormal];
    }
}

- (IBAction)stopButton:(id)sender {
    
    //if the app is not in its default state when 'stop' is pushed
    if(![startLapButtonLabel.titleLabel.text isEqual: @"Start"])
    {
        //stop the timer and reset everything to its startup state
        [timer invalidate];
    
        [startLapButtonLabel setTitle:@"Start" forState:UIControlStateNormal];
    
        lapCount = 1;
        millisecondsSinceStartOfCurrentLap = 0;
        totalTimeInMilliseconds = 0;
    
        totalTime.text = @"00:00.0";
        
        lapTime.text = @"";
        lastLapTime.text = @"";
        secondToLastLapTime.text = @"";
        lapName.text = @"";
        lastLapName.text = @"";
        secondToLastLapName.text = @"";
    }
}
@end
