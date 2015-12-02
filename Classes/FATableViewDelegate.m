//
//  FAAbstractTableViewDelegate.m
//  FATableViewController
//
//  Created by Rasmus Kildevæld on 08/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FATableViewDelegate.h"

@implementation FATableViewDelegate

+ (instancetype)delegateWithDataSource:(id<FATableViewDataSourceProtocol>)dataSource {
    return [[self alloc] initWithDataSource:dataSource];
}

- (id)initWithDataSource:(id<FATableViewDataSourceProtocol>)dataSource {
    if ((self = [super init])) {
        _dataSource = dataSource;
        self.footerHeight = 0.f;
        self.headerHeight = 0.f;
        self.rowHeight = -1.f;
    }
    return self;
}

- (id)init {
    @throw([NSException exceptionWithName:@"Init" reason:@"You should use dedicated initializer" userInfo:nil]);
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return ([super respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector]);
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    if ([super respondsToSelector:anInvocation.selector]) {
        [super forwardInvocation:anInvocation];
    } else if ([self.delegate respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.delegate];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
    
    if (self.animation)
        [self.animator tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
    
    if (self.animation) {
        [self.animator scrollViewDidScroll:scrollView];
    }
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.rowHeight >= 0)
        return self.rowHeight;

    return tableView.rowHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)index {
    if (self.headerHeight >= 0) {
        return self.headerHeight;
    }
    
    return tableView.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.footerHeight >= 0) {
        return self.footerHeight;
    }
    return tableView.sectionFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)index {
    id section = [self.dataSource sectionAtIndex:index];
    
    if (!section)
        return nil;
    
    NSString *identifier = self.headerIdentifier;
    
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    }
    
    if (self.configureHeader)
        self.configureHeader(view, index);
    else {
        if ([section isKindOfClass:NSString.class]) {
            view.textLabel.text = section;
        }
    }
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)index {
    id section = [self.dataSource sectionAtIndex:index];
    
    if (!section)
        return nil;
    
    NSString *identifier = self.footerIdentifier;
    
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    }
    
    if (self.configureFooter)
        self.configureFooter(view, index);
    else {
        if ([section isKindOfClass:NSString.class]) {
            view.textLabel.text = section;
        }
    }
    
    return view;
}


#pragma mark Selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id data = [self.dataSource dataAtIndexPath:indexPath];
    if (self.onRowSelected)
        self.onRowSelected(indexPath, data);
}

- (void)setAnimation:(BOOL)animation {
    _animation = animation;
    if (animation) {
        _animator = [[FATableViewAnimator alloc] initWithTableView:self.tableView];
        
    } else {
        _animator = nil;
    }
}

- (void)setOnRowSelectedBlock:(onRowSelectedBlock)block {
    self.onRowSelected = block;
}

@end
