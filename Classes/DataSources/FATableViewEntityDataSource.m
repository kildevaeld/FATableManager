//
//  JDTableViewDataSource.m
//  LiveJazz iPad
//
//  Created by Rasmus Kildevæld on 5/23/13.
//  Copyright (c) 2013 Rasmus Kildevæld. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "FATableViewDataSourceProtocol.h"
#import "FATableViewDataSourceDelegate.h"

#import "FATableViewEntityDataSource.h"
#import "NSString+FetchedGroupByString.h"
#import "FATableViewCellProtocol.h"
#import <Foundation/Foundation.h>
//#import "FALog.h"

@class NSManagedObjectContext;
@protocol FATableViewCell;

//static const int FALogContext = FA_TABLEVIEW_LOG_CONTEXT;
//static const int FALogLevel = FA_LOG_LEVEL_VERBOSE;

@interface FATableViewEntityDataSource ()

@property (nonatomic, strong, readwrite) NSFetchedResultsController *fetchedResultsController;
//@property (nonatomic, strong,) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) NSArray *fetchedObjects;


- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end

@implementation FATableViewEntityDataSource

- (NSString*)sectionAtIndex:(NSUInteger)index {
    NSString *section = [[self.fetchedResultsController sections][index] name];
	
	/*if ([self.delegate respondsToSelector:@selector(formatSection:)]) {
		return [self.delegate formatSectionTitle:section];
	}*/
	return section;
}

- (id)dataAtIndexPath:(NSIndexPath*)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.fetchedResultsController sections].count;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
   	id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (BOOL)performFetch:(NSError **)error {
    bool ret = [self.fetchedResultsController performFetch:error];
    self.fetchedObjects = self.fetchedResultsController.fetchedObjects;
    return ret;
}

#pragma mark - Predicates
- (void)setPredicate:(NSPredicate*)predicate {
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
}

- (NSPredicate*)predicate {
    return self.fetchedResultsController.fetchRequest.predicate;
}

#pragma mark - FetchedResultsController Delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
            if ([self.delegate respondsToSelector:@selector(dataSource:didUpdateObject:atIdenxPath:)]) {
                [self.delegate dataSource:self didUpdateObject:[self dataAtIndexPath:indexPath] atIndexPath:indexPath];
            } else {
                [self tableView:self.tableView configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            }
            
            break;
			
        case NSFetchedResultsChangeMove:
			[self.tableView deleteRowsAtIndexPaths:[NSArray
											   arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView insertRowsAtIndexPaths:[NSArray
											   arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	//NSLog(@"TYPE %i",type);
    switch(type) {
		case NSFetchedResultsChangeUpdate:
            [self.tableView reloadData];
            break;
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName {
	return sectionName;
}

#pragma mark - Getter
- (NSFetchedResultsController*)fetchedResultsController {
	if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
	
    if (nil == self.entity || nil == self.sortKey || nil == self.cellIdentifier) {
       // FALogWarn(@"FATableViewDataSource : You have to specify : entity, sortKey and cellIdentifier");
        return nil;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
								   entityForName:self.entity inManagedObjectContext:self.managedObjectContext];
    
	[fetchRequest setEntity:entity];
	
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
							  initWithKey:self.sortKey ascending:YES];
    
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
	
    [fetchRequest setFetchBatchSize:self.batchSize];
	
	//[NSFetchedResultsController deleteCacheWithName:@"Root"];
    _fetchedResultsController = [[NSFetchedResultsController alloc]
                                                               initWithFetchRequest:fetchRequest
                                                               managedObjectContext:self.managedObjectContext
                                                               sectionNameKeyPath:self.sectionNameKeyPath
                                                               cacheName:self.cacheName];
    
    _fetchedResultsController.delegate = self;
	
    return _fetchedResultsController;
}

- (void)dealloc {
    [self.fetchedResultsController setDelegate:nil];
}

@end
