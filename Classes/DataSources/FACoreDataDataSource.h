//
//  JDTableViewDataSource.h
//  LiveJazz iPad
//
//  Created by Rasmus Kildevæld on 5/23/13.
//  Copyright (c) 2013 Rasmus Kildevæld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FAAbstractTableViewDataSource.h"

@class NSFetchedResultsController;
@protocol  NSFetchedResultsControllerDelegate;

@interface FACoreDataDataSource : FAAbstractTableViewDataSource <NSFetchedResultsControllerDelegate> {
    
}


@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, copy) NSString *entity;

@property (nonatomic) NSUInteger batchSize;

@property (nonatomic,copy) NSString *cacheName;


@end
