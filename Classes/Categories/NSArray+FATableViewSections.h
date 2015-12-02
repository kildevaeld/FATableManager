//
//  NSArray+FATableViewSections.h
//  FATableViewController
//
//  Created by Rasmus Kildevaeld on 12/08/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FATableViewSections)

- (NSArray *)sectionizeWithSortKey:(NSString *)string sectionKeyPath:(NSString *)keyPath ascending:(BOOL)yes;

- (NSArray *)sectionizeWithSortKey:(NSString *)string sectionKeyPath:(NSString *)keyPath predicate:(NSPredicate*)predicate ascending:(BOOL)yes;


@end
