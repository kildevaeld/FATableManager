//
//  FAbstractTableViewDataSource.h
//  FATableViewController
//
//  Created by Rasmus Kildevaeld on 11/08/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FATableViewDataSourceProtocol.h"
#import "FATableviewDataSourceDelegate.h"

 
@protocol FATableViewDataSourceDelegate;

/*!
 * @abstract This is a baseclass for datasource classes
 */
@interface FAAbstractTableViewDataSource : NSObject <FATableViewDataSourceProtocol>

@property (nonatomic, weak) id<FATableViewDataSourceDelegate> delegate;

@property (nonatomic, weak) id<UITableViewDataSource> proxy;

/** A sort key */
@property (nonatomic, copy) NSString *sortKey;

@property (nonatomic) BOOL sortAscending;
/** Which keypath should be used to generate the section */
@property (nonatomic, copy) NSString *sectionNameKeyPath;
/** Cell Identifier */
@property (nonatomic, copy) NSString *cellIdentifier;
/** When you do a performFetch: this is array will be */
@property (nonatomic, strong, readonly) NSArray *fetchedObjects;
/** A predicate to use for filtering data */
@property (nonatomic, strong) NSPredicate *predicate;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) FAConfigureCellBlock configureCell;


+ (instancetype)dataSourceWithTableView:(UITableView *)tableView;

- (id)initWithTableView:(UITableView *)tableView;

///
/// @name Predicates
///
/** Add a predicate to the predicate using 'and' */
- (void)andPredicate:(NSPredicate *)predicate;
/** Add a predicate to the predicate using 'or' */
- (void)orPredicate:(NSPredicate *)predicate;

- (void)tableView:(UITableView *)tableView configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)setConfigureCellBlock:(FAConfigureCellBlock)block;

@end
