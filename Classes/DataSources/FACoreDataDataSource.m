
//
//  JDTableViewDataSource.m
//  LiveJazz iPad
//
//  Created by Rasmus Kildevæld on 5/23/13.
//  Copyright (c) 2013 Rasmus Kildevæld. All rights reserved.
//
#import <CoreData/CoreData.h>

#import "FACoreDataDataSource.h"
#import "NSString+FetchedGroupByString.h"
#import "FATableViewDataSourceDelegate.h"

#import <Foundation/Foundation.h>


@interface FACoreDataDataSource ()


@end

@implementation FACoreDataDataSource


- (NSString*)sectionAtIndex:(NSUInteger)index {
    NSString *section = [[self.fetchedResultsController sections][index] name];
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
    
    return ret;
}

- (void)clear {
    
    if (self.tableView.numberOfSections == 0)
        return;
    
    [self.tableView beginUpdates];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:
                            NSMakeRange(0, self.fetchedResultsController.sections.count)];
    
    [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    self.fetchedResultsController.delegate = nil;
    _fetchedResultsController = nil;
    
    [self.tableView endUpdates];
}

#pragma mark - Predicates
- (void)setPredicate:(NSPredicate*)predicate {
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
}

- (NSPredicate*)predicate {
    return self.fetchedResultsController.fetchRequest.predicate;
}

- (NSArray *)fetchedObjects {
    return _fetchedResultsController.fetchedObjects;
}

#pragma mark - FetchedResultsController Delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            if ([self.delegate respondsToSelector:@selector(dataSource:didInsertObject:atIndexPath:)]) {
                [self.delegate dataSource:self didInsertObject:[self dataAtIndexPath:indexPath] atIndexPath:indexPath];
            } else {
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            break;
			
        case NSFetchedResultsChangeDelete:
            if ([self.delegate respondsToSelector:@selector(dataSource:didDeleteObject:atIndexPath:)]) {
                [self.delegate dataSource:self didDeleteObject:[self dataAtIndexPath:indexPath] atIndexPath:indexPath];
            } else {
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            break;
			
        case NSFetchedResultsChangeUpdate:
            if ([self.delegate respondsToSelector:@selector(dataSource:didUpdateObject:atIndexPath:)]) {
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
	
    switch(type) {
		case NSFetchedResultsChangeUpdate:
            [self.tableView reloadData];
            break;
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
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
	
    if (nil == self.entity || nil == self.sortKey ) {
        NSLog(@"FATableViewDataSource : You have to specify : entity and sortKey");
        return nil;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
								   entityForName:self.entity inManagedObjectContext:self.managedObjectContext];
    
	[fetchRequest setEntity:entity];
	
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
							  initWithKey:self.sortKey ascending:self.sortAscending];
    
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
	
    [fetchRequest setFetchBatchSize:self.batchSize];
	
    _fetchedResultsController = [[NSFetchedResultsController alloc]
                                                               initWithFetchRequest:fetchRequest
                                                               managedObjectContext:self.managedObjectContext
                                                               sectionNameKeyPath:self.sectionNameKeyPath
                                                               cacheName:nil];
    
    _fetchedResultsController.delegate = self;
	
    
    return _fetchedResultsController;
}




- (void)dealloc {
    [self.fetchedResultsController setDelegate:nil];
}

@end
