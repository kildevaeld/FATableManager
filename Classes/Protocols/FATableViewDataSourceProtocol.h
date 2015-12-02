//
//  FADataSourceProtocol.h
//  FATableViewController
//
//  Created by Rasmus Kildevaeld on 10/08/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FAConfigureCellBlock)(UITableViewCell *cell, NSIndexPath *indexPath,id item);


@protocol UITableViewDataSource;
/** FATableViewDataSourceProtocol */
@protocol FATableViewDataSourceProtocol <NSObject, UITableViewDataSource>
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, weak) id delegate;

@property (nonatomic, copy) NSString *sortKey;
@property (nonatomic, copy) NSString *sectionNameKeyPath;
@property (nonatomic) BOOL sortAscending;
@property (nonatomic, copy) FAConfigureCellBlock configureCell;

- (void)setTableView:(UITableView *)tableView;
/** Performs form a fetch */
- (BOOL)performFetch:(NSError**)error;
/** Get section at index */
- (id)sectionAtIndex:(NSUInteger)index;
/** Get the data at indexPath */
- (id)dataAtIndexPath:(NSIndexPath*)indexPath;

- (NSArray *)fetchedObjects;

- (void)clear;

@optional

- (NSString *)entity;

- (NSManagedObjectContext *)managedObjectContext;

- (void)setEntity:(NSString *)entity;

- (void)setManagedObjectContext:(NSManagedObjectContext *)context;


@end
