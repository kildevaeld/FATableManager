//
//  FATableViewDynamicDataSource.h
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 05/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FAAbstractTableViewDataSource.h"
#import "FATableViewDynamicSection.h"
#import "FATableViewDynamicItem.h"
#import "FATableViewDynamicDelegate.h"

@interface FATableViewDynamicDataSource : FAAbstractTableViewDataSource <FATableViewDynamicSectionDelegate> {
    NSMutableArray *_dataSource;
}

@property (nonatomic, strong) UITableView *tableView;

+ (instancetype)dataSourceWithTableView:(UITableView *)tableView;

- (id)initWithTableView:(UITableView *)tableView;

- (void)addSection:(FATableViewDynamicSection *)section;

- (void)addSection:(FATableViewDynamicSection *)section toIndex:(NSUInteger)index;

- (FATableViewDynamicSection *)addSection;

- (FATableViewDynamicSection *)addSectionWithTitle:(NSString *)title;

- (FATableViewDynamicSection *)addSectionWithTitle:(NSString *)title height:(CGFloat)height;

- (FATableViewDynamicSection *)sectionAtIndex:(NSUInteger)index;

- (void)removeSectionAtIndex:(NSInteger)index;

- (void)removeSection:(FATableViewDynamicSection *)section;

- (void)clear;

@end
