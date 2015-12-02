//
//  FATableViewDelegateProtocol.h
//  FATableViewController
//
//  Created by Rasmus Kildevæld on 09/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^configureSectionBlock)(UITableViewHeaderFooterView *view, NSInteger section);
typedef void(^onRowSelectedBlock)(NSIndexPath *indexPath, id data);


@protocol FATableViewDataSourceProtocol;

@protocol FATableViewDelegateProtocol <NSObject, UITableViewDelegate>

@property (nonatomic, copy) onRowSelectedBlock onRowSelected;
@property (nonatomic, copy) configureSectionBlock configureHeader;
@property (nonatomic, copy) configureSectionBlock configureFooter;


- (id)initWithDataSource:(id<FATableViewDataSourceProtocol>)dataSource;

- (void)setDataSource:(id<FATableViewDataSourceProtocol>)dataSource;

@end
