//
//  FATableViewAnimator.m
//  FATableViewController
//
//  Created by Rasmus Kildevæld on 09/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FATableViewAnimator.h"
#import <QuartzCore/QuartzCore.h>

NSTimeInterval ADLivelyDefaultDuration = 0.2;

CGFloat CGFloatSign(CGFloat value) {
    if (value < 0) {
        return -1.0f;
    }
    return 1.0f;
}

ADLivelyTransform ADLivelyTransformCurl = ^(CALayer * layer, float speed){
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500;
    transform = CATransform3DTranslate(transform, -layer.bounds.size.width/2.0f, 0.0f, 0.0f);
    transform = CATransform3DRotate(transform, M_PI/2, 0.0f, 1.0f, 0.0f);
    layer.transform = CATransform3DTranslate(transform, layer.bounds.size.width/2.0f, 0.0f, 0.0f);
    return ADLivelyDefaultDuration;
};

ADLivelyTransform ADLivelyTransformFade = ^(CALayer * layer, float speed){
    if (speed != 0.0f) { // Don't animate the initial state
        layer.opacity = 1.0f - fabs(speed);
    }
    return 2 * ADLivelyDefaultDuration;
};

ADLivelyTransform ADLivelyTransformFan = ^(CALayer * layer, float speed){
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, -layer.bounds.size.width/2.0f, 0.0f, 0.0f);
    transform = CATransform3DRotate(transform, -M_PI/2 * speed, 0.0f, 0.0f, 1.0f);
    layer.transform = CATransform3DTranslate(transform, layer.bounds.size.width/2.0f, 0.0f, 0.0f);
    layer.opacity = 1.0f - fabs(speed);
    return ADLivelyDefaultDuration;
};

ADLivelyTransform ADLivelyTransformFlip = ^(CALayer * layer, float speed){
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0.0f, CGFloatSign(speed) * layer.bounds.size.height/2.0f, 0.0f);
    transform = CATransform3DRotate(transform, CGFloatSign(speed) * M_PI/2, 1.0f, 0.0f, 0.0f);
    layer.transform = CATransform3DTranslate(transform, 0.0f, -CGFloatSign(speed) * layer.bounds.size.height/2.0f, 0.0f);
    layer.opacity = 1.0f - fabs(speed);
    return 2 * ADLivelyDefaultDuration;
};

ADLivelyTransform ADLivelyTransformHelix = ^(CALayer * layer, float speed){
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0.0f, CGFloatSign(speed) * layer.bounds.size.height/2.0f, 0.0f);
    transform = CATransform3DRotate(transform, M_PI, 0.0f, 1.0f, 0.0f);
    layer.transform = CATransform3DTranslate(transform, 0.0f, -CGFloatSign(speed) * layer.bounds.size.height/2.0f, 0.0f);
    layer.opacity = 1.0f - 0.2*fabs(speed);
    return 2 * ADLivelyDefaultDuration;
};

ADLivelyTransform ADLivelyTransformTilt = ^(CALayer * layer, float speed){
    if (speed != 0.0f) { // Don't animate the initial state
        layer.transform = CATransform3DMakeScale(0.8f, 0.8f, 0.8f);
        layer.opacity = 1.0f - fabs(speed);
    }
    return 2 * ADLivelyDefaultDuration;
};

ADLivelyTransform ADLivelyTransformWave = ^(CALayer * layer, float speed){
    if (speed != 0.0f) { // Don't animate the initial state
        layer.transform = CATransform3DMakeTranslation(-layer.bounds.size.width/2.0f, 0.0f, 0.0f);
    }
    return ADLivelyDefaultDuration;
};


@implementation FATableViewAnimator

- (id)initWithTableView:(UITableView *)tableView {
    if ((self = [super init])) {
        self.tableView = tableView;
    }
    return self;
}

- (id)init {
    @throw ([NSException exceptionWithName:nil reason:nil userInfo:nil]);
}

#pragma mark - ADLivelyTableView
- (CGPoint)scrollSpeed {
    return CGPointMake(_lastScrollPosition.x - _currentScrollPosition.x,
                       _lastScrollPosition.y - _currentScrollPosition.y);
}

- (void)setInitialCellTransformBlock:(ADLivelyTransform)block {
    CATransform3D transform = CATransform3DIdentity;
    if (block != nil) {
        transform.m34 = -1.0/self.tableView.bounds.size.width;
    }
    self.tableView.layer.transform = transform;
    
    if (block != _transformBlock) {
        
        _transformBlock = [block copy];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _lastScrollPosition = _currentScrollPosition;
    _currentScrollPosition = [scrollView contentOffset];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    float speed = self.scrollSpeed.y;
    float normalizedSpeed = MAX(-1.0f, MIN(1.0f, speed/20.0f));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_transformBlock) {
            NSTimeInterval animationDuration = _transformBlock(cell.layer, normalizedSpeed);
            // The block-based equivalent doesn't play well with iOS 4
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animationDuration];
        }
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.opacity = 1.0f;
        if (_transformBlock) {
            [UIView commitAnimations];
        }
    });
}

- (void)setAnimationBlock:(ADLivelyTransform)animationBlock {
    [self setInitialCellTransformBlock:animationBlock];
}
@end
