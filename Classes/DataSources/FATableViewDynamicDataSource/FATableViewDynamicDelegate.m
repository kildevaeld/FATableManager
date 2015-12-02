//
//  FATableViewDynamicDelegate.m
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 05/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FATableViewDynamicDelegate.h"
#import "FATableViewDynamicDataSource.h"

@implementation FATableViewDynamicDelegate

/*- (id)initWithDataSource:(id<FATableViewDataSourceProtocol>)dataSource {
    if ((self = [super init])) {
        _dataSource = dataSource;
    }
    return self;
}*/

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FATableViewDynamicItem *item = [self.dataSource dataAtIndexPath:indexPath];
    
    if (item && item.height >= 0)
        return item.height;
    
    return tableView.rowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)index {
    FATableViewDynamicSection *section = (FATableViewDynamicSection *)[self.dataSource sectionAtIndex:index];
    
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
        view.textLabel.text = section.title;
        
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)index {
    FATableViewDynamicSection *section = (FATableViewDynamicSection *)[self.dataSource sectionAtIndex:index];
    
    CGFloat height = (section.height >= 0) ? section.height : [super tableView:tableView heightForHeaderInSection:index];
    
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FATableViewDynamicItem *item = [self.dataSource dataAtIndexPath:indexPath];
    
    if (item && item.onRowSelected)
        item.onRowSelected(indexPath, item);
    else if (self.onRowSelected)
        self.onRowSelected(indexPath, item);
}

@end
