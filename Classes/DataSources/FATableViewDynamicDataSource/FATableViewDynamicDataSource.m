//
//  FATableViewDynamicDataSource.m
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 05/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FATableViewDynamicDataSource.h"

@implementation FATableViewDynamicDataSource

+ (instancetype)dataSourceWithTableView:(UITableView *)tableView {
    return [[self alloc] initWithTableView:tableView];
}

- (id)initWithTableView:(UITableView *)tableView {
    if ((self = [super initWithTableView:tableView])) {
        _dataSource = [NSMutableArray new];
    }
    return self;
}

- (void)addSection:(FATableViewDynamicSection *)section {
    NSUInteger index = [_dataSource indexOfObject:_dataSource.lastObject];
    if (index == NSNotFound)
        index = 0;
    else
        index++;
    [self addSection:section toIndex:index];
}

- (void)addSection:(FATableViewDynamicSection *)section toIndex:(NSUInteger)index {
    
    section.delegate = self;
    
    [self.tableView beginUpdates];
    
    [_dataSource insertObject:section atIndex:index];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.tableView endUpdates];

}

- (FATableViewDynamicSection *)addSection {
    return [self addSectionWithTitle:nil];
}

- (FATableViewDynamicSection *)addSectionWithTitle:(NSString *)title {
    return [self addSectionWithTitle:title height:-1.0f];
}

- (FATableViewDynamicSection *)addSectionWithTitle:(NSString *)title height:(CGFloat)height {
    FATableViewDynamicSection *section = [FATableViewDynamicSection sectionWithTitle:title height:height];
    
    [self addSection:section];
    
    return section;
}

- (void)removeSectionAtIndex:(NSInteger)index {
    if (index < _dataSource.count) {
        [self.tableView beginUpdates];
        
        [_dataSource removeObjectAtIndex:index];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView endUpdates];
    }
}

- (void)removeSection:(FATableViewDynamicSection *)section {
    [self.tableView beginUpdates];
    NSUInteger index = [_dataSource indexOfObject:section];
    [_dataSource removeObject:section];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)index {
    FATableViewDynamicSection *section = (index >= _dataSource.count) ? nil : _dataSource[index];
    if (section) {
        return section.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FATableViewDynamicItem *item = [self dataAtIndexPath:indexPath];
    
    UITableViewCell *cell;
    NSString *cellIdentifier = item.cellIdentifier;
    
    if (!cellIdentifier) {
        cellIdentifier = self.cellIdentifier;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (item.configureCell) {
        item.configureCell(cell,item);
    } else {
        [self tableView:tableView configureCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - FATableviewDataSource Protocol
- (BOOL)performFetch:(NSError **)error {
    return YES;
}
/** Get section at index */
- (FATableViewDynamicSection *)sectionAtIndex:(NSUInteger)index {
    FATableViewDynamicSection *section = (index >= _dataSource.count) ? nil : _dataSource[index];
    if (section) {
        return section;
    }
    return nil;
}
/** Get the data at indexPath */
- (FATableViewDynamicItem *)dataAtIndexPath:(NSIndexPath*)indexPath {
    FATableViewDynamicSection *section = (indexPath.section >= _dataSource.count) ? nil : _dataSource[indexPath.section];
    if (section) {
        FATableViewDynamicItem *item = (indexPath.row >= section.count) ? nil : section[indexPath.row];
        return item;
    }
    return nil;
}


- (NSArray *)fetchedObjects {
    NSMutableArray *array = [NSMutableArray new];
    for (FATableViewDynamicSection *section in _dataSource) {
        @autoreleasepool {
            for (FATableViewDynamicItem *item in section) {
                [array addObject:item];
            }
        }
    }
    return [NSArray arrayWithArray:array];
}

- (void)clear {
    _dataSource = [NSMutableArray new];
    [self.tableView reloadData];
}


#pragma mark - FATableViewDynamicSection Delegate
- (void)section:(FATableViewDynamicSection *)section didRemoveRow:(FATableViewDynamicItem *)row atIndex:(NSUInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:[_dataSource indexOfObject:section]];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)section:(FATableViewDynamicSection *)section willRemoveRow:(FATableViewDynamicItem *)row atIndex:(NSUInteger)index {
    
}

- (void)section:(FATableViewDynamicSection *)section willInsertRow:(FATableViewDynamicItem *)row atIndex:(NSUInteger)index {
    
}

- (void)section:(FATableViewDynamicSection *)section didInsertRow:(FATableViewDynamicItem *)row atIndex:(NSUInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:[_dataSource indexOfObject:section]];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"Sections : %@",_dataSource];
}
@end
