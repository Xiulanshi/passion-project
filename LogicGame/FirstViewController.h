//
//  FirstViewController.h
//  LogicGame
//
//  Created by Xiulan Shi on 2/25/16.
//  Copyright © 2016 Diana Elezaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface FirstViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) NSArray *pageContent;

@end
