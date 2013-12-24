//
//  SrollViewController.h
//  scrollview
//
//  Created by lc on 13-12-3.
//  Copyright (c) 2013 lc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCGridView.h"

@interface SrollViewController : UIViewController<LCGridViewDelegate>

{
    LCGridView *_scroll;
}

@property (nonatomic, retain) LCGridView *scroll;


@end
