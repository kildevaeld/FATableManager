//
//  FATableViewDynamicDelegate.h
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 05/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FATableViewDelegate.h"

@class FATableViewDynamicDataSource, FATableViewDynamicItem, FATableViewDynamicSection;
@protocol FATableViewDataSourceProtocol;

@interface FATableViewDynamicDelegate : FATableViewDelegate <UITableViewDelegate>

@property (nonatomic, weak) id<UITableViewDelegate> delegate;
//@property (nonatomic, weak) id<FATableViewDataSourceProtocol> dataSource;
//@property (nonatomic, copy) void (^onRowSelected)(NSIndexPath *indexPath, FATableViewDynamicItem *item);

//- (id)initWithDataSource:(FATableViewDynamicDataSource *)dataSource;

@end
