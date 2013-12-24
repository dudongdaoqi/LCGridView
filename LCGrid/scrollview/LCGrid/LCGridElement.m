//
//  LCGridElement.m
//  scrollview
//
//  Created by lc on 13-12-20.
//  Copyright (c) 2013 lc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "LCGridElement.h"
#import "LCGridData.h"

//the magin is x multiple of width
#define kMarginScale 0.05
//the height of label
#define kLabelHeightScale 0.2
//the distance between label and image is x multiple of magin
#define kLabelGap 2

@implementation LCGridElement

@synthesize data = _data;
@synthesize mainView = _mainView;
@synthesize image = _image;
@synthesize label = _label;

- (void)dealloc
{
    [_data release];
    [_mainView release];
    [_image release];
    [_label release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setupUI];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame name:(LCGridData *)gridData
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _data = [gridData retain];
        // tap gesture for toggling the switch
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(didTap:)];
        [tapGesture setDelegate:self];
        [self addGestureRecognizer:tapGesture];

        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gridBG"]];
        [self setupUI];
    }
    return self;
}



-(void) didTap:(UITapGestureRecognizer*)gesture
{
    self.backgroundColor = [UIColor colorWithRed:0.0078 green:0.6862 blue:1 alpha:1];
    [self performSelector:@selector(getBlack:) withObject:self afterDelay:0.3];
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
       [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)getBlack:(UIView *)sender
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gridBG"]];
}

- (void)setupUI
{
    self.clipsToBounds = YES;
    
    UIView *v = [[UIView alloc]init];
    self.mainView = v, [v release];
    [self addSubview:self.mainView];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_data.imageName]];
    self.image = image, [image release];
    [v addSubview:self.image];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = _data.labelName;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        label.font = [UIFont systemFontOfSize:14];
    }
    self.label = label, [label release];
    [v addSubview:self.label];
}


- (void)setupFrame
{
    float width = CGRectGetWidth(self.frame);
    float height = CGRectGetHeight(self.frame);
    
    float newWidth = width > height ? height : width;
    
    //margin
    float margin = newWidth * kMarginScale;
    //the distance between label and image
    float labelGap = kLabelGap * margin;
    //the height of the label
    float labelHeight = newWidth * kLabelHeightScale;
    //total height
    float iconWidth = newWidth - 2 * margin;

    float imagWidth = newWidth * 0.6;
    
    CGRect rect = CGRectMake(0, 0, newWidth, newWidth);
    _mainView.frame = rect;
    _mainView.center = CGPointMake(width * 0.5, height * 0.5);
    
    _image.frame = CGRectMake(0, 0, imagWidth, imagWidth);
    _image.center = CGPointMake(newWidth * 0.5, margin + imagWidth * 0.5);
    
    _label.frame = CGRectMake(0, 0, iconWidth, labelHeight);
    _label.center = CGPointMake(newWidth * 0.5, margin + imagWidth + labelGap + labelHeight * 0.5);
    
}


@end
