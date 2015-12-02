//
//  JDTableViewDataSource.h
//  LiveJazz iPad
//
//  Created by Rasmus Kildevæld on 5/23/13.
//  Copyright (c) 2013 Rasmus Kildevæld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FATableViewDataSourceDelegate.h"
#import "FATableViewDataSourceProtocol.h"

#import "FAAbstractTableViewDataSource.h"

@class NSFetchedResultsController;
@protocol  NSFetchedResultsControllerDelegate;

@interface FATableViewEntityDataSource : FAAbstractTableViewDataSource <NSFetchedResultsControllerDelegate> {
    
}

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, copy) NSString *entity;

@property (nonatomic) NSUInteger batchSize;

@property (nonatomic,copy) NSString *cacheName;


@end
