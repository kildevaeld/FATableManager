//
//  FATableViewDynamicSection.m
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 05/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FATableViewDynamicSection.h"

@implementation FATableViewDynamicSection

- (id)init {
    if ((self = [super init])) {
        _items = [NSMutableArray new];
        _height = 0.f;
    }
    return self;
}

+ (instancetype)sectionWithTitle:(NSString *)title {
    return [self sectionWithTitle:title height:-1.f];
}

+ (instancetype)sectionWithTitle:(NSString *)title height:(CGFloat)height {
    FATableViewDynamicSection *section = [self new];
    section.title = title;
    section.height = height;
    return section;
}

- (FATableViewDynamicItem *)addRowWithData:(id)data {
    return [self addRowWithData:data height:-1.f cellIdentifier:nil];
}

- (FATableViewDynamicItem *)addRowWithData:(id)data height:(CGFloat)height cellIdentifier:(NSString *)cellIdentifier {
    FATableViewDynamicItem *item = [FATableViewDynamicItem itemWithModel:data height:height cellIdentifier:cellIdentifier];
    [self insertRow:item];
    
    return item;
}

- (void)insertRow:(FATableViewDynamicItem *)row {
    NSUInteger index = [_items indexOfObject:_items.lastObject];
    index = index == NSNotFound ? 0 : ++index;
    [self insertRow:row atIndex:index];
    
}

- (void)insertRow:(FATableViewDynamicItem *)row atIndex:(NSUInteger)index {
    if ([self.delegate respondsToSelector:@selector(section:willInsertRow:atIndex:)]) {
        [self.delegate section:self willInsertRow:row atIndex:index];
    }
    
    [_items insertObject:row atIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(section:didInsertRow:atIndex:)]) {
        [self.delegate section:self didInsertRow:row atIndex:index];
    }
}

- (void)removeRowAtIndex:(NSUInteger)index {
    id row = [_items objectAtIndex:index];
    [self removeRow:row];
}

- (void)removeRow:(FATableViewDynamicItem *)row {
    NSUInteger index = [_items indexOfObject:row];
    
    if ([self.delegate respondsToSelector:@selector(section:willRemoveRow:atIndex:)]) {
        [self.delegate section:self willRemoveRow:row atIndex:index];
    }
    
    [_items removeObject:row];
    
    if ([self.delegate respondsToSelector:@selector(section:didRemoveRow:atIndex:)]) {
        [self.delegate section:self didRemoveRow:row atIndex:index];
    }
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx < self.count)
        return _items[idx];
    return nil;
}
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if (idx <= self.count)
        [_items insertObject:obj atIndex:idx];
}

- (NSUInteger)count {
    return _items.count;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    return [_items countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<title: %@, data: %@>",self.title,_items];
}

@end
