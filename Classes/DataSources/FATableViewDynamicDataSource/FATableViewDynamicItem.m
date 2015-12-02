//
//  FATableViewDynamicItem.m
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 05/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FATableViewDynamicItem.h"

@implementation FATableViewDynamicItem


+ (instancetype)itemWithModel:(id)model {
    return [self itemWithModel:model height:-1.f];
}

+ (instancetype)itemWithModel:(id)model height:(CGFloat)height {
    return [self itemWithModel:model height:height cellIdentifier:nil];
}

+ (instancetype)itemWithModel:(id)model height:(CGFloat)height cellIdentifier:(NSString *)cellIdentifier {
    FATableViewDynamicItem *item = [self new];
    
    item.model = model;
    item.height = height;
    item.cellIdentifier = cellIdentifier;
    
    return item;
}

- (id)valueForKeyPath:(NSString *)keyPath {
    if (_model)
        return [_model valueForKeyPath:keyPath];
    return [super valueForKeyPath:keyPath];
}

- (id)valueForKey:(NSString *)key {
    if (_model)
        return [_model valueForKey:key];
    return [super valueForKey:key];
}

- (id)objectForKeyedSubscript:(id <NSCopying>)key {
    if (_model) {
        return [_model valueForKeyPath:(NSString *)key];
    }
    return nil;
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
    if (_model) {
        [_model setValue:obj forKeyPath:(NSString *)key];
    }
}

@end
