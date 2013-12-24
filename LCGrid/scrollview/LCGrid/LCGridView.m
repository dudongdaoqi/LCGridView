//
//  SrollView.m
//  scrollview
//
//  Created by lc on 13-12-3.
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

#import "LCGridView.h"


#import "LCGridElement.h"

#define kPageControlHeight ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)?20:40)
#define kViewHeight CGRectGetHeight(self.frame)
#define kViewWidth CGRectGetWidth(self.frame)
#define kTableViewHeight (CGRectGetHeight(self.frame) - kPageControlHeight)
#define kIconSizeScale 0.8
#define kGapScale 0.05

@interface LCGridView() <UIScrollViewDelegate>

@property (nonatomic, retain) UIImageView *backgroundImageView;

@end


@implementation LCGridView

@synthesize backgroundImageView = _backgroundImageView;
@synthesize delegate = _delegate;
@synthesize row = _row;
@synthesize column = _column;

- (void)dealloc
{
    [_scrollView release];
    [_backgroundImageView release];
    [_pageControl release];
    [_elementSource release];
    [_dataSource release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame withSource:(NSMutableArray *)array withRowNum:(NSInteger)row withColumnNum:(NSInteger)column isPageControl:(BOOL)isPage
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _elementSource = [[NSMutableArray alloc]initWithCapacity:0];
        _dataSource = [[NSMutableArray alloc]initWithArray:array];
        _row = row;
        _column = column;
        _isPage = isPage;
        [self loadUI];
    }
    return self;
}

- (void)loadUI
{
    UIImageView *v = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Sky.jpg"]];
    v.frame = self.bounds;
    self.backgroundImageView = v,[v release];
    [self addSubview:self.backgroundImageView];

    if (_dataSource.count <= 0 || self.column <= 0|| self.row <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"sorry" message:@"the data for the grid is wrong！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.frame = self.frame;
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_scrollView];
    
    [self setupUI:_dataSource];
    [self setupFrame];
}


- (void)setupFrame
{
    _scrollView.frame = self.frame;
    self.backgroundImageView.frame = self.frame;
 
    NSInteger dataCount = _elementSource.count;
    NSInteger totalRow = (dataCount % self.column) ? (dataCount / self.column + 1) : (dataCount / self.column);
    
    CGRect newRect = CGRectZero;
    
    //more than one screen
    if (totalRow > self.row)
    {
        NSInteger num = (totalRow % self.row) ? (totalRow / self.row + 1) : (totalRow / self.row);
        //is page controll
        if (_isPage)
        {
            if (num > 1)
            {
                _scrollView.pagingEnabled = YES;
                
                CGSize size = CGSizeMake(CGRectGetWidth(self.frame) * num, CGRectGetHeight(self.frame));
                [_scrollView setContentSize:size];
                
                if (!_pageControl)
                {
                    _pageControl = [[UIPageControl alloc]init];
                }
                
                _pageControl.frame =CGRectMake(0, _scrollView.frame.size.height-kPageControlHeight, kViewWidth, kPageControlHeight);
                _pageControl.numberOfPages = num;
                _pageControl.currentPage = 0;
                [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
                [self addSubview:_pageControl];
            }
            
            for (int i = 0; i < num; i++)
            {
                NSRange rang = NSMakeRange(i * self.row * self.column, ((i != num-1 )? (self.row * self.column): (dataCount-(num-1)*self.row*self.column)));
                NSMutableIndexSet *_index = [NSMutableIndexSet indexSetWithIndexesInRange:rang];
                NSArray *arr = [_elementSource objectsAtIndexes:_index];

                float height = CGRectGetHeight(self.frame);
                float width = CGRectGetWidth(self.frame);
                newRect.origin.x = i * width;
                newRect.origin.y = CGRectGetMinY(self.frame);
                newRect.size.width = width;
                newRect.size.height = height - kPageControlHeight;
                [self setScrollView:newRect withData:(NSMutableArray *)arr isPage:YES page:i];
            }
        }
        else
        {
            CGSize size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * num);
            [_scrollView setContentSize:size];
            
            for (int i = 0; i < num; i++)
            {
                float height = CGRectGetHeight(self.frame);
                newRect.origin.y = i * height;
                newRect.origin.x = CGRectGetMinX(self.frame);
                newRect.size.width = self.frame.size.width;
                newRect.size.height = self.frame.size.height;
                [self setScrollView:self.frame withData:_elementSource isPage:NO page:0];
            }
        }
    }
    else
    {
        [self setScrollView:self.frame withData:_elementSource isPage:NO page:0];
    }
}


-(void)setScrollView:(CGRect)newRect withData:(NSMutableArray *)arr isPage:(BOOL)isPage page:(NSInteger)page
{
    NSInteger elementCount = arr.count;
    float width = CGRectGetWidth(newRect);
    float height = CGRectGetHeight(newRect);
    //column distance   
    float column_d = width / self.column;
    //row distance
    float row_d = height / self.row;
    //margin 
    float margin = (column_d > row_d ? row_d : column_d) * kGapScale;
    //the width and height of the icon
    float icon_width = (width - (self.column + 1) * margin)/self.column;
    float icon_height = (height- (self.row + 1) * margin)/self.row;
    //the distance of column and row
    float column_distance = icon_width + margin;
    float row_distance = icon_height + margin;
    
    for (NSInteger i = 0;i < elementCount;)
    {
        CGFloat y = margin + icon_height * 0.5 + (i / self.column) * row_distance;
        for (NSInteger col = 0; (col < self.column) && (i < elementCount); col++)
        {
            LCGridElement *ele = [arr objectAtIndex:i++];
            CGFloat x = margin + icon_width * 0.5 + col * column_distance + (isPage?page * width:0);
            CGRect itemViewFrame = CGRectZero;
            itemViewFrame.size = CGSizeMake(icon_width, icon_height);
            ele.frame = itemViewFrame;
            ele.center = CGPointMake(x, y);
            [ele setupFrame];
        }
    }
}

- (void)setupUI:(NSMutableArray *)array
{
    for (int i = 0; i < array.count; i++)
    {
        LCGridElement *ele = [[LCGridElement alloc]initWithFrame:CGRectZero name:[array objectAtIndex:i]];
        [ele addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [_elementSource addObject:ele];
        [_scrollView addSubview:ele];
        [ele release];
    }
}

- (void)btnDown:(LCGridElement *)ele
{
    if ([self.delegate respondsToSelector:@selector(touchAction:)]) {
        [self.delegate touchAction:ele.data.labelName];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int p = _scrollView.contentOffset.x / 320;
    _pageControl.currentPage = p;
}



- (void)changePage:(id)sender
{
	/*
	 *	Change the scroll view
	 */
    
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * _pageControl.currentPage;
    frame.origin.y = 0;
	
    [_scrollView scrollRectToVisible:frame animated:YES];
	
	/*
	 *	When the animated scrolling finishings, scrollViewDidEndDecelerating will turn this off
	 */
    //pageControlIsChangingPage = YES;
}

@end
