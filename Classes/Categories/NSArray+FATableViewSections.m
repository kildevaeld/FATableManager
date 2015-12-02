//
//  NSArray+FATableViewSections.m
//  FATableViewController
//
//  Created by Rasmus Kildevaeld on 12/08/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import "NSArray+FATableViewSections.h"

@implementation NSArray (FATableViewSections)

- (NSArray *)sectionizeWithSortKey:(NSString *)sortKey sectionKeyPath:(NSString *)keyPath ascending:(BOOL)ascending {
    return [self sectionizeWithSortKey:sortKey sectionKeyPath:keyPath predicate:nil ascending:ascending];
}

- (NSArray *)sectionizeWithSortKey:(NSString *)sortKey sectionKeyPath:(NSString *)keyPath predicate:(NSPredicate*)predicate ascending:(BOOL)ascending {
    
    NSArray *sortDescriptor = @[ [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending] ];
    
    NSArray *array;
    if (predicate) {
        array = [[self filteredArrayUsingPredicate:predicate] sortedArrayUsingDescriptors:sortDescriptor];
     } else {
         array = [self sortedArrayUsingDescriptors:sortDescriptor];
     }
    
    NSMutableArray *items = [NSMutableArray new];
    if (keyPath) {
        for (id item in array) {
            NSMutableDictionary *section;
            NSString *sectionLabel;
            sectionLabel = [item valueForKeyPath:keyPath];
            
            
            // Check if section already exists
            
            NSUInteger index = [items indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                NSString *sec = [obj valueForKey:@"section"];
                if ([sec isEqualToString:sectionLabel]) return YES;
                return NO;
            }];
            
            if (index == NSNotFound) {
                section = [NSMutableDictionary dictionaryWithDictionary:@{@"section":sectionLabel,@"rows":[NSMutableArray new]}];
                [items addObject:section];
            } else {
                section = [items objectAtIndex:index];
            }
            
            [section[@"rows"] addObject:item];
        }
        return [items copy];
    }
    return array;
}

@end
