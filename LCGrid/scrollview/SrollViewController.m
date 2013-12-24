//
//  SrollViewController.m
//  scrollview
//
//  Created by lc on 13-12-3.
//  Copyright (c) 2013 lc. All rights reserved.
//

#import "SrollViewController.h"
#import "LCGridData.h"

#define kGridNum 3

@interface SrollViewController ()

@end

@implementation SrollViewController

@synthesize scroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)touchAction:(NSString *)sender
{
    NSLog(@"touch:%@",sender);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:12];

    
    for (int i = 0; i < 20; i++)
    {
        NSString *image = nil;
        if (i % 2) {
            image = @"123.png";
        }
       else  if (i % 3) {
            image = @"digg.png";
        }
        else
        {
            image = @"evernote.png";
        }
        LCGridData *data = [[LCGridData alloc]initWith:image label:[NSString stringWithFormat:@"test%i",i+1]];
        [array addObject:data],[data release];
    }
    
    CGRect newRect = self.view.bounds;
    
    _scroll = [[LCGridView alloc]initWithFrame:newRect withSource:array withRowNum:kGridNum withColumnNum:kGridNum isPageControl:YES];
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    
//}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setFrame:self.view withOrientation:toInterfaceOrientation];
    [self setupFrame];
}

- (void)setupFrame
{
    _scroll.frame = self.view.frame;
    [_scroll setupFrame];
    
}

#define kNormalStatusHeight (20)
#define kPhoneVerticalStatusHeight (20)
#define kZero 0

- (void)setFrame:(UIView *)view withOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    float width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    float height = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            view.frame = CGRectMake(kZero, kZero, width>height?width:height, (width<height?width:height)-kPhoneVerticalStatusHeight);
        }
        else
        {
            view.frame = CGRectMake(kZero, kZero, width>height?width:height, (width<height?width:height)-kNormalStatusHeight);
        }
    }
    else
    {
        view.frame = CGRectMake(kZero, kZero, (width<height?width:height), (width>height?width:height)-kNormalStatusHeight);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
