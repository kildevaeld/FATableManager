//
//  FAbstractTableViewDataSource.m
//  FATableViewController
//
//  Created by Rasmus Kildevaeld on 11/08/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import "FAAbstractTableViewDataSource.h"
#import "FATableViewDataSourceProtocol.h"
#import "FATableViewDataSourceDelegate.h"
#import "FATableViewCellProtocol.h"

#define mustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]


@interface FAAbstractTableViewDataSource ()

@property (nonatomic, strong, readwrite) NSArray *fetchedObjects;

@end

@implementation FAAbstractTableViewDataSource

+ (instancetype)dataSourceWithTableView:(UITableView *)tableView {
    return [[self alloc] initWithTableView:tableView];
}

- (id)initWithTableView:(UITableView *)tableView {
    if ((self = [super init])) {
        _tableView = tableView;
    }
    return self;
}

- (id)init {
    @throw([NSException exceptionWithName:@"Init" reason:@"You should use dedicated initializer" userInfo:nil]);
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    
    return ([super respondsToSelector:aSelector] || [self.proxy respondsToSelector:aSelector]);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    if ([super respondsToSelector:anInvocation.selector]) {
        [super forwardInvocation:anInvocation];
    } else if ([self.proxy respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.proxy];
    }
}


- (NSString *)sectionAtIndex:(NSUInteger)index {
    mustOverride();
}

- (id)dataAtIndexPath:(NSIndexPath *)indexPath {
    mustOverride();
}

- (BOOL)performFetch:(NSError **)error {
    mustOverride();
}

- (void)clear {
    mustOverride();
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    
    [self tableView:tableView configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath {
	id data = [self dataAtIndexPath:indexPath];
	
    // If configureCell is set
    if (self.configureCell) {
        self.configureCell(cell,indexPath,data);
    
    // If delegate is set and responds.
    } else if ([self.delegate respondsToSelector:@selector(tableView:configureCell:withData:)]) {
        [self.delegate tableView:tableView configureCell:cell withData:data];
    
    // If the cell conform to FATableCell
    } else if ([cell conformsToProtocol:@protocol(FATableViewCellProtocol)]) {
        [cell arrangeWithData:data];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    mustOverride();
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    mustOverride();
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.proxy respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        [self.proxy tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.proxy respondsToSelector:_cmd]) {
        return [self.proxy tableView:tableView canEditRowAtIndexPath:indexPath];
    } else if ([self.proxy respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]) {
        return YES;
    }
    return NO;
}


- (void)andPredicate:(NSPredicate *)predicate {
    NSPredicate *compound = predicate;
    if (self.predicate) {
        compound = [NSCompoundPredicate andPredicateWithSubpredicates:@[self.predicate,predicate]];
    }
    self.predicate = compound;
}

- (void)orPredicate:(NSPredicate *)predicate {
    NSPredicate *compund = predicate;
    if (nil != self.predicate) {
        compund = [NSCompoundPredicate orPredicateWithSubpredicates:@[self.predicate,predicate]];
    }
    self.predicate = compund;
}

- (void)setConfigureCellBlock:(FAConfigureCellBlock)block {
    self.configureCell = block;
}

@end
