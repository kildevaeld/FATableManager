//
//  FATableViewDataSourceDelegate.h
//  FALibraries
//
//  Created by Rasmus Kildevaeld on 09/06/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FATableViewDataSourceProtocol;

@protocol FATableViewDataSourceDelegate <NSObject>

@optional

- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell withData:(id)data;

- (void)dataSource:(id<FATableViewDataSourceProtocol>)dataSource didUpdateObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

- (void)dataSource:(id<FATableViewDataSourceProtocol>)dataSource didDeleteObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

- (void)dataSource:(id<FATableViewDataSourceProtocol>)dataSource didInsertObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

- (void)dataSourceDidChange:(id<FATableViewDataSourceProtocol>)dataSoruce;

@end