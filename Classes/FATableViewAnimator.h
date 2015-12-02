//
//  FATableViewAnimator.h
//  FATableViewController
//
//  Created by Rasmus Kildevæld on 09/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSTimeInterval ADLivelyDefaultDuration;
typedef NSTimeInterval (^ADLivelyTransform)(CALayer * layer, float speed);

extern ADLivelyTransform ADLivelyTransformCurl;
extern ADLivelyTransform ADLivelyTransformFade;
extern ADLivelyTransform ADLivelyTransformFan;
extern ADLivelyTransform ADLivelyTransformFlip;
extern ADLivelyTransform ADLivelyTransformHelix;
extern ADLivelyTransform ADLivelyTransformTilt;
extern ADLivelyTransform ADLivelyTransformWave;


@interface FATableViewAnimator : NSObject <UITableViewDelegate> {
    CGPoint _lastScrollPosition;
    CGPoint _currentScrollPosition;
    ADLivelyTransform _transformBlock;
}

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) ADLivelyTransform animationBlock;

- (id)initWithTableView:(UITableView *)tableView;

- (CGPoint)scrollSpeed;
- (void)setInitialCellTransformBlock:(ADLivelyTransform)block;

@end
