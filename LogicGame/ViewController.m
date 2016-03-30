//
//  ViewController.m
//  LogicGame
//
//  Created by Diana Elezaj on 2/20/16.
//  Copyright © 2016 Diana Elezaj. All rights reserved.
//

#import "ViewController.h"
#import "SCLAlertView.h"
#import "Line.h"
#import <AVFoundation/AVFoundation.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface ViewController ()
@property (nonatomic) CGPoint start;
@property (nonatomic) CGPoint end;
@property (nonatomic) UIColor *color;
@property (strong, nonatomic) NSMutableArray *allLines;
@property (strong, nonatomic) Line *currentDrawing;
@property (nonatomic) BOOL currentlyDrawing;
@property (nonatomic, strong) AVPlayer *avplayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self awakeFromNib];
    [self startPlayer];
  
 }

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.avplayer pause];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.avplayer play];
}

- (void)awakeFromNib
{
    [self initializePoints];
    self.allLines = [NSMutableArray new];
    [self roundButtons];
    [self hideViews];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // iterate through all the lines and draw line.  Draw line good for glory of Russia line.
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
    self.start = [[touches anyObject] locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Grab the current point
    self.currentlyDrawing = YES;
    self.end = [[touches anyObject] locationInView:self.view];
    self.color = [UIColor blackColor];
    
    [self.view setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.end = [[touches anyObject] locationInView:self.view];
    NSLog(@"endd %f %f",self.end.x, self.end.y);
    
    //check button one1 possible lines
    if ((([self clickedButton:self.one1 at:self.start]) && ([self clickedButton:self.four1 atEnd:self.end])) || (([self clickedButton:self.four1 at:self.start]) && ([self clickedButton:self.one1 atEnd:self.end])))
    {
        _oneFourView1.hidden = NO;
        NSLog(@"Correct line");
        self.end = [[touches anyObject] locationInView:self.view];
        self.color = [UIColor blackColor];
        self.currentlyDrawing = NO;
        [self addPoint];
    }
    else if ((([self clickedButton:self.two1 at:self.start]) && ([self clickedButton:self.eight1 atEnd:self.end])) || (([self clickedButton:self.eight1 at:self.start]) && ([self clickedButton:self.two1 atEnd:self.end])))  {
        if (_twoEightView1.hidden)
        _twoEightView1.hidden = NO;
        else if (_twoEightView2.hidden){
            _twoEightView2.hidden = NO;
        }
        NSLog(@"Correct line");
        self.end = [[touches anyObject] locationInView:self.view];
        self.color = [UIColor blackColor];
        self.currentlyDrawing = NO;
        [self addPoint];
    }
    
    else if ((([self clickedButton:self.four1 at:self.start]) && ([self clickedButton:self.eight1 atEnd:self.end])) || (([self clickedButton:self.eight1 at:self.start]) && ([self clickedButton:self.four1 atEnd:self.end]))) {
        if (_fourEightView.hidden)
        _fourEightView.hidden = NO;
        else if (_fourEightView2.hidden) {
            _fourEightView2.hidden = NO;
        }
        NSLog(@"Correct line");
        self.end = [[touches anyObject] locationInView:self.view];
        self.color = [UIColor blackColor];
        self.currentlyDrawing = NO;
        [self addPoint];
    }
    
    else if ((([self clickedButton:self.four1 at:self.start]) && ([self clickedButton:self.one2 atEnd:self.end])) || (([self clickedButton:self.one2 at:self.start]) && ([self clickedButton:self.four1 atEnd:self.end]))){
        _fourOneView1.hidden = NO;
        NSLog(@"Correct line");
        self.end = [[touches anyObject] locationInView:self.view];
        self.color = [UIColor blackColor];
        self.currentlyDrawing = NO;
        [self addPoint];
    }
        //check button eight1 possible lines
    else if ((([self clickedButton:self.eight1 at:self.start]) && ([self clickedButton:self.two1 atEnd:self.end])) || (([self clickedButton:self.two1 at:self.start]) && ([self clickedButton:self.eight1 atEnd:self.end]))) {
        if (_twoEightView1.hidden) {
        _twoEightView1.hidden = NO;
        }
        else if (_twoEightView2.hidden) {
            _twoEightView2.hidden = NO;
        }
        NSLog(@"Correct line");
        self.end = [[touches anyObject] locationInView:self.view];
        self.color = [UIColor blackColor];
        self.currentlyDrawing = NO;
        [self addPoint];
    }
    
    else if ((([self clickedButton:self.eight1 at:self.start]) && ([self clickedButton:self.four2 atEnd:self.end])) || (([self clickedButton:self.four2 at:self.start]) && ([self clickedButton:self.eight1 atEnd:self.end]))) {
        if (_eightFourView1.hidden) {
            _eightFourView1.hidden = NO;
        }
        else if (_eightFourView2.hidden) {
            _eightFourView2.hidden = NO;
        }
        NSLog(@"Correct line");
        self.end = [[touches anyObject] locationInView:self.view];
        self.color = [UIColor blackColor];
        self.currentlyDrawing = NO;
        [self addPoint];
    }
    
    else if ((([self clickedButton:self.eight1 at:self.start]) && ([self clickedButton:self.two2 atEnd:self.end])) || (([self clickedButton:self.two2 at:self.start]) && ([self clickedButton:self.eight1 atEnd:self.end]))){
        if (_eightTwoView1.hidden){
            _eightTwoView1.hidden = NO;
        }
        else if (_eightTwoView2.hidden){
            _eightTwoView2.hidden = NO;
        }
        NSLog(@"Correct line");
        self.end = [[touches anyObject] locationInView:self.view];
        self.color = [UIColor blackColor];
        self.currentlyDrawing = NO;
        [self addPoint];
    }
        //check button four2 possible lines

    else if ((([self clickedButton:self.four2 at:self.start]) && ([self clickedButton:self.two3 atEnd:self.end])) || (([self clickedButton:self.two3 at:self.start]) && ([self clickedButton:self.four2 atEnd:self.end]))){
        if (_fourTwoView1.hidden) {
            _fourTwoView1.hidden = NO;
        }
        else if (_fourTwoView2.hidden){
            _fourTwoView2.hidden = NO;
        }
        NSLog(@"Correct line");
        self.end = [[touches anyObject] locationInView:self.view];
        self.color = [UIColor blackColor];
        self.currentlyDrawing = NO;
        [self addPoint];
    }
    
    else if ((([self clickedButton:self.two2 at:self.start]) && ([self clickedButton:self.two3 atEnd:self.end])) || (([self clickedButton:self.two3 at:self.start]) && ([self clickedButton:self.two2 atEnd:self.end]))){
        _twoTwoView.hidden = NO;
        NSLog(@"Correct line");
        self.end = [[touches anyObject] locationInView:self.view];
        self.color = [UIColor blackColor];
        self.currentlyDrawing = NO;
        [self addPoint];
    }
    
    //wrong connection
    else {
        [self  notAllowedPopup];
        
        [self.view setNeedsDisplay];
    }
}

-(BOOL)clickedButton :(UIButton *)button at:(CGPoint)point{
    if (((point.x > button.frame.origin.x) &&  (point.x < (button.frame.origin.x + button.frame.size.width))) && (point.y > button.frame.origin.y) &&  (point.y < (button.frame.origin.y + button.frame.size.height))) {
        button.backgroundColor = [UIColor yellowColor];
        return YES;
    }
    return NO;
}

-(BOOL)clickedButton :(UIButton *)button atEnd:(CGPoint)point{
    if (((point.x > button.frame.origin.x) &&  (point.x < (button.frame.origin.x + button.frame.size.width))) && (point.y > button.frame.origin.y) &&  (point.y < (button.frame.origin.y + button.frame.size.height))) {
         return YES;
    }
    return NO;
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"Device started shaking...");
        self.allLines = [NSMutableArray new];
        [self.view setNeedsDisplay];
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
    [self roundedButtons:_two1];
    [self roundedButtons:_two2];
    [self roundedButtons:_two3];
    [self roundedButtons:_four1];
    [self roundedButtons:_four2];
    [self roundedButtons:_eight1];
}

-(void)addPoint{
    //Add point to end
    if ([self clickedButton:self.one1 at:self.end]) {
        _one1Point++;
        
        //change color if points are correct
        if (_one1Point == 1) {
            [self changeButtonsColorIfIsCompleted:_one1];
        }
        if (_one1Point > 1) {
            [self changeButtonsColorIfIsWrong:_one1];
        }
    }   if ([self clickedButton:self.one2 at:self.end]) {
        _one2Point ++;
        if (_one2Point == 1) {
            [self changeButtonsColorIfIsCompleted:_one2];
        }
        if (_one2Point > 1) {
            [self changeButtonsColorIfIsWrong:_one2];
        }
    }   if ([self clickedButton:self.two1 at:self.end]) {
        _two1Point++;
        if (_two1Point == 2) {
            [self changeButtonsColorIfIsCompleted:_two1];
        }
        if (_two1Point > 2) {
            [self changeButtonsColorIfIsWrong:_two1];
        }
    }   if ([self clickedButton:self.two2 at:self.end]) {
        _two2Point++;
        if (_two2Point == 2) {
            [self changeButtonsColorIfIsCompleted:_two2];
        }
        if (_two2Point > 2) {
            [self changeButtonsColorIfIsWrong:_two2];
        }
    }    if ([self clickedButton:self.two3 at:self.end]) {
        _two3Point++;
        if (_two3Point == 2) {
            [self changeButtonsColorIfIsCompleted:_two3];
        }
        if (_two3Point > 2) {
            [self changeButtonsColorIfIsWrong:_two3];
        }
    }    if ([self clickedButton:self.four1 at:self.end]) {
        _four1Point++;
        if (_four1Point == 4) {
            [self changeButtonsColorIfIsCompleted:_four1];
        }
        if (_four1Point > 4) {
            [self changeButtonsColorIfIsWrong:_four1];
        }
    }   if ([self clickedButton:self.four2 at:self.end]) {
        _four2Point++;
        if (_four2Point == 4) {
            [self changeButtonsColorIfIsCompleted:_four2];
        }
        if (_four2Point > 4) {
            [self changeButtonsColorIfIsWrong:_four2];
        }
    }   if ([self clickedButton:self.eight1 at:self.end]) {
        _eight1Point++;
        if (_eight1Point == 8) {
            [self changeButtonsColorIfIsCompleted:_eight1];
        }
        if (_eight1Point > 8) {
            [self changeButtonsColorIfIsWrong:_eight1];
        }
    }
    
    //add point to start
    if ([self clickedButton:self.one1 at:self.start]) {
        _one1Point++;
        if (_one1Point == 1) {
            [self changeButtonsColorIfIsCompleted:_one1];
        }
        if (_one1Point > 1) {
            [self changeButtonsColorIfIsWrong:_one1];
        }
    }   if ([self clickedButton:self.one2 at:self.start]) {
        _one2Point ++;
        if (_one2Point == 1) {
            [self changeButtonsColorIfIsCompleted:_one2];
        }
        if (_one2Point > 1) {
            [self changeButtonsColorIfIsWrong:_one2];
        }
    }   if ([self clickedButton:self.two1 at:self.start]) {
        _two1Point++;
        if (_two1Point == 2) {
            [self changeButtonsColorIfIsCompleted:_two1];
        }
        if (_two1Point > 2) {
            [self changeButtonsColorIfIsWrong:_two1];
        }
    }   if ([self clickedButton:self.two2 at:self.start]) {
        _two2Point++;
        if (_two2Point == 2) {
            [self changeButtonsColorIfIsCompleted:_two2];
        }
        if (_two2Point > 2) {
            [self changeButtonsColorIfIsWrong:_two2];
        }
    }    if ([self clickedButton:self.two3 at:self.start]) {
        _two3Point++;
        if (_two3Point == 2) {
            [self changeButtonsColorIfIsCompleted:_two3];
        }
        if (_two3Point > 2) {
            [self changeButtonsColorIfIsWrong:_two3];
        }
    }    if ([self clickedButton:self.four1 at:self.start]) {
        _four1Point++;
        if (_four1Point == 4) {
            [self changeButtonsColorIfIsCompleted:_four1];
        }
        if (_four1Point > 4) {
            [self changeButtonsColorIfIsWrong:_four1];
        }
    }   if ([self clickedButton:self.four2 at:self.start]) {
        _four2Point++;
        if (_four2Point == 4) {
            [self changeButtonsColorIfIsCompleted:_four2];
        }
        if (_four2Point > 4) {
            [self changeButtonsColorIfIsWrong:_four2];
        }
    }   if ([self clickedButton:self.eight1 at:self.start]) {
        _eight1Point++;
        if (_eight1Point == 8) {
            [self changeButtonsColorIfIsCompleted:_eight1];
        }
        if (_eight1Point > 8) {
            [self changeButtonsColorIfIsWrong:_eight1];
        }
    }
    
    [self checkIfIsWinner];
    
}

-(void)initializePoints{
    _one1Point = 0;
    _one2Point = 0;
    _two1Point = 0;
    _two2Point = 0;
    _two3Point = 0;
    _four1Point = 0;
    _four2Point = 0;
    _eight1Point = 0;
}

-(void)checkIfIsWinner{
    //check if all buttons have the correct number of lines
    if ((_one1Point == 1)
        && (_two1Point == 2)
        && (_four1Point == 4)
        && (_eight1Point == 8)
        && (_four2Point == 4)
        && (_one2Point == 1)
        && (_two2Point == 2)
        && (_two3Point == 2)) {
        [self winnerPopup];
    }
}

-(void)changeButtonsColorIfIsCompleted:(UIButton *)button {
    button.backgroundColor = [UIColor greenColor];
}

-(void)changeButtonsColorIfIsWrong:(UIButton *)button {
    button.backgroundColor = [UIColor redColor];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)notAllowedPopup {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showCustom:self image:[UIImage imageNamed:@"wrong"] color:[UIColor redColor] title:@"Error" subTitle:@"Line not allowed" closeButtonTitle:@"OK" duration:0.0f];
}
-(void)winnerPopup {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showCustom:self image:[UIImage imageNamed:@"winner"] color:[UIColor redColor] title:@"Congratulations!" subTitle:@"YOU WON!" closeButtonTitle:@"OK" duration:0.0f];
}

-(void)hideViews{
    _fourEightView.hidden = YES;
    _fourEightView2.hidden = YES;
    _oneFourView1.hidden = YES;
    _twoEightView1.hidden = YES;
    _twoEightView2.hidden = YES;
    _fourOneView1.hidden = YES;
    _fourOneView2.hidden = YES;
    _fourTwoView1.hidden = YES;
    _fourTwoView2.hidden = YES;
    _eightFourView1.hidden = YES;
    _eightFourView2.hidden = YES;
    _eightTwoView1.hidden = YES;
    _eightTwoView2.hidden = YES;
    _twoTwoView.hidden = YES;
    
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
- (IBAction)deleteButtonPressed:(UIButton *)sender {
    self.twoTwoView.hidden = YES;
    self.two2.backgroundColor = [UIColor greenColor];
    self.two3.backgroundColor = [UIColor greenColor];
    self.two2Point--;
    self.two3Point--;
    [self checkIfIsWinner];
}


@end
