//
//  FAAbstractTableViewDelegate.h
//  FATableViewController
//
//  Created by Rasmus Kildevæld on 08/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FATableViewDataSourceProtocol.h"
#import "FATableViewAnimator.h"
#import "FATableViewDelegateProtocol.h"


@interface FATableViewDelegate : NSObject <UITableViewDelegate, FATableViewDelegateProtocol>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) FATableViewAnimator *animator;
@property (nonatomic, getter = shouldAnimate) BOOL animation;

@property (nonatomic, weak) id<UITableViewDelegate> delegate;
@property (nonatomic, weak) id<FATableViewDataSourceProtocol> dataSource;

/// @name Sections
/** Set section header height */
@property (nonatomic) CGFloat headerHeight;
/** Set section footer height */
@property (nonatomic) CGFloat footerHeight;
/** Set section header identifier */
@property (nonatomic, copy) NSString *headerIdentifier;
/** Set section footer identifier */
@property (nonatomic, copy) NSString *footerIdentifier;
@property (nonatomic) CGFloat rowHeight;

@property (nonatomic, copy) configureSectionBlock configureHeader;
@property (nonatomic, copy) configureSectionBlock configureFooter;
@property (nonatomic, copy) onRowSelectedBlock onRowSelected;


+ (instancetype)delegateWithDataSource:(id<FATableViewDataSourceProtocol>)dataSource;

- (id)initWithDataSource:(id<FATableViewDataSourceProtocol>)dataSource;

- (void)setOnRowSelectedBlock:(onRowSelectedBlock)block;

@end
