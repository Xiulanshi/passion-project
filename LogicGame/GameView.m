//
//  GameView.m
//  LogicGame
//
//  Created by Diana Elezaj on 2/22/16.
//  Copyright © 2016 Diana Elezaj. All rights reserved.
//

#import "GameView.h"
#import "Line.h"
#import <AVFoundation/AVFoundation.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface GameView()
@property (nonatomic) CGPoint start;
@property (nonatomic) CGPoint end;
@property (nonatomic) UIColor *color;
@property (strong, nonatomic) NSMutableArray *allLines;
@property (strong, nonatomic) Line *currentDrawing;
@property (nonatomic) BOOL currentlyDrawing;
@property (nonatomic, strong) AVPlayer *avplayer;


@end

@implementation GameView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    self.allLines = [NSMutableArray new];
    [self roundButtons];
    NSLog(@"two 1%@ ",self.two1);
    [self startPlayer];

}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // iterate through all ze lines and draw line.  Draw line good for glory of Russia line.
    for (Line *line in self.allLines) {
        [line drawLineWithContext:context];
    }
    if (self.currentlyDrawing) {
        [self.currentDrawing drawLineWithContext:context];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // capture the location where the user starts touching the view
    self.start = [[touches anyObject] locationInView:self];
    NSLog(@" start %f  %f", self.start.x, self.start.y);
    
    //clicked button 1
    if ([self clickedButton:self.two1 at:self.start ]) {
        NSLog(@"starttttt");
    }
    
}

-(BOOL)clickedButton :(UIButton *)button at:(CGPoint)point{
    if (((point.x > button.frame.origin.x) &&  (point.x < (button.frame.origin.x + button.frame.size.width))) && (point.y > button.frame.origin.y) &&  (point.y < (button.frame.origin.y + button.frame.size.height))) {
        
        button.backgroundColor = [UIColor redColor];
        NSLog(@"yayyyy");
        return YES;
    }
    return NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Grab the current point
    self.currentlyDrawing = YES;
    self.end = [[touches anyObject] locationInView:self];
    self.color = [UIColor blackColor];
    
    
    self.currentDrawing = [Line initWithStartPoint:self.start withEndPoint:self.end withColor:self.color];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.end = [[touches anyObject] locationInView:self];
    NSLog(@" end %f %f", self.end.x, self.end.y);
    
    self.color = [UIColor blackColor];
    self.currentlyDrawing = NO;
    [self.allLines addObject:[Line initWithStartPoint:self.start withEndPoint:self.end withColor:self.color]];
    [self setNeedsDisplay];
    
    if ([self clickedButton:self.two2 at:self.end]) {
        NSLog(@"enddd");
        
    }
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"Device started shaking...");
        self.allLines = [NSMutableArray new];
        [self setNeedsDisplay];
    }
}

-(void)roundedButtons:(UIButton*)button{
    button.layer.cornerRadius = button.frame.size.width/2;
    button.clipsToBounds = YES;
    [[button layer] setBorderWidth:2.0f];
    [[button layer] setBorderColor:[UIColor blackColor].CGColor];
    button.backgroundColor = [UIColor whiteColor];
}

-(void)roundButtons{
    [self roundedButtons:_one1];
    [self roundedButtons:_one2];
    [self roundedButtons:_one3];
    [self roundedButtons:_one4];
    [self roundedButtons:_one5];
    [self roundedButtons:_two1];
    [self roundedButtons:_two2];
    [self roundedButtons:_two3];
    [self roundedButtons:_two4];
    [self roundedButtons:_two5];
    [self roundedButtons:_two6];
    [self roundedButtons:_two7];
    [self roundedButtons:_two8];
    [self roundedButtons:_three1];
    [self roundedButtons:_three2];
    [self roundedButtons:_three3];
    [self roundedButtons:_three4];
    [self roundedButtons:_three5];
    [self roundedButtons:_four1];
    [self roundedButtons:_five1];
    [self roundedButtons:_five2];
    [self roundedButtons:_five3];
    [self roundedButtons:_five4];
    [self roundedButtons:_six1];
    [self roundedButtons:_eight1];
}

-(void)startPlayer{
    
    //Not affecting background music playing
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    //Set up player
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"brain" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:filePath];
    
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:[[UIScreen mainScreen] bounds]];
    [self.movieView.layer addSublayer:avPlayerLayer];
    
    //Config player
    [self.avplayer seekToTime:kCMTimeZero];
    [self.avplayer setVolume:0.0f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerStartPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //Config dark gradient view
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[UIScreen mainScreen] bounds];
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0x000000) CGColor], (id)[[UIColor clearColor] CGColor], (id)[UIColorFromRGB(0x000000) CGColor],nil];
    [self.gradientView.layer insertSublayer:gradient atIndex:0];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)playerStartPlaying
{
    [self.avplayer play];
}

@end
