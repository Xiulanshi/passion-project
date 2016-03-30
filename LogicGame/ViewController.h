//
//  ViewController.h
//  LogicGame
//
//  Created by Diana Elezaj on 2/20/16.
//  Copyright © 2016 Diana Elezaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameView.h"
@interface ViewController : UIViewController
-(void)notAllowedPopup ;
@property (weak, nonatomic) IBOutlet UIButton *one1;
@property (weak, nonatomic) IBOutlet UIButton *two1;
@property (weak, nonatomic) IBOutlet UIButton *four1;
@property (weak, nonatomic) IBOutlet UIButton *eight1;
@property (weak, nonatomic) IBOutlet UIButton *four2;
@property (weak, nonatomic) IBOutlet UIButton *two2;
@property (weak, nonatomic) IBOutlet UIButton *two3;
@property (weak, nonatomic) IBOutlet UIButton *one2;

//lines
@property (weak, nonatomic) IBOutlet UIView *fourEightView;
@property (weak, nonatomic) IBOutlet UIView *oneFourView1;
@property (weak, nonatomic) IBOutlet UIView *twoEightView1;
@property (weak, nonatomic) IBOutlet UIView *twoEightView2;
@property (weak, nonatomic) IBOutlet UIView *fourEightView2;
@property (weak, nonatomic) IBOutlet UIView *fourOneView1;
@property (weak, nonatomic) IBOutlet UIView *eightFourView1;
@property (weak, nonatomic) IBOutlet UIView *eightFourView2;
@property (weak, nonatomic) IBOutlet UIView *eightTwoView1;
@property (weak, nonatomic) IBOutlet UIView *eightTwoView2;
@property (weak, nonatomic) IBOutlet UIView *fourTwoView2;
@property (weak, nonatomic) IBOutlet UIView *fourTwoView1;
@property (weak, nonatomic) IBOutlet UIView *fourOneView2;
@property (weak, nonatomic) IBOutlet UIView *twoTwoView;

@property (weak, nonatomic) IBOutlet UIView *movieView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;


@property (nonatomic) NSInteger one1Point;
@property (nonatomic) NSInteger two1Point;
@property (nonatomic) NSInteger four1Point;
@property (nonatomic) NSInteger eight1Point;
@property (nonatomic) NSInteger four2Point;
@property (nonatomic) NSInteger two2Point;
@property (nonatomic) NSInteger two3Point;
@property (nonatomic) NSInteger one2Point;

@end

