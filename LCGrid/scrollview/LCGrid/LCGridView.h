//
//  SrollView.h
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

#import <UIKit/UIKit.h>
#import "LCGridData.h"

@protocol LCGridViewDelegate <NSObject>

- (void)touchAction:(NSString *)sender;

@end

@interface LCGridView : UIView
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSMutableArray*_dataSource;
    NSMutableArray *_elementSource;
    NSInteger _row;
    NSInteger _column;
    BOOL _isPage;
}

@property (nonatomic, assign, readonly) NSInteger row;
@property (nonatomic, assign, readonly) NSInteger column;
@property (nonatomic, assign) id<LCGridViewDelegate> delegate;

//one screen the number of row and column; if have UIPageControl
- (id)initWithFrame:(CGRect)frame withSource:(NSMutableArray *)array withRowNum:(NSInteger)row withColumnNum:(NSInteger)column isPageControl:(BOOL)isPage;
- (void)setupFrame;

@end//view model
