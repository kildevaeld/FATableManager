//
//  FATableViewArrayDataSource.m
//  FATableViewController
//
//  Created by Rasmus Kildevaeld on 10/08/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import "FATableViewArrayDataSource.h"
#import "FATableViewDataSourceProtocol.h"
#import "FATableViewCellProtocol.h"
#import "FATableViewDataSourceDelegate.h"

#import "NSArray+FATableViewSections.h"

@interface FATableViewArrayDataSource ()
//@property (nonatomic, strong, readwrite) NSArray *fetchedObjects;

@end

@implementation FATableViewArrayDataSource

@synthesize fetchedObjects = _fetchedObjects;


- (BOOL)performFetch:(NSError **)error {

    NSAssert(self.sortKey, @"No sortkey");
    
    NSArray *items;
    if (self.predicate) {
        items = [self.data filteredArrayUsingPredicate:self.predicate];
    } else {
        items = self.data;
    }
    
    NSArray *sortDescriptor = @[ [[NSSortDescriptor alloc] initWithKey:self.sortKey ascending:self.sortAscending] ];
    
    NSArray *sortedArray = [items sortedArrayUsingDescriptors:sortDescriptor];
    
    
    NSMutableArray *sections = [NSMutableArray new];
    
    // Use sections
    if (self.sectionNameKeyPath) {
        for (id item in sortedArray) {
            NSString *key = [item valueForKeyPath:self.sectionNameKeyPath];
            NSInteger index = [sections indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                FATableViewDynamicSection *section = (FATableViewDynamicSection*)obj;
                if ([section.title isEqualToString:key])
                    return YES;
                return NO;
            }];
            FATableViewDynamicSection *section;
            if (index == NSNotFound) {
                section = [FATableViewDynamicSection sectionWithTitle:key];
                [sections addObject:section];
            } else {
                section = sections[index];
            }
            [section addRowWithData:item height:-1 cellIdentifier:self.cellIdentifier];
        }
        
        for (id section in sections) {
            [self addSection:section];
        }
        
    } else {
        FATableViewDynamicSection *section = [self addSection];
        for (id item in sortedArray) {
            [section addRowWithData:item height:-1 cellIdentifier:self.cellIdentifier];
        }
    }
    
    _fetchedObjects = items;
    
    return YES;
}




@end
