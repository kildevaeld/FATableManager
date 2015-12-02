//
//  FATableViewDynamicItem.h
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 05/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FATableViewDynamicItem : NSObject

@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic) CGFloat height;
@property (nonatomic, strong) id model;

@property (nonatomic, copy) void (^configureCell)(UITableViewCell *cell,FATableViewDynamicItem *item);
@property (nonatomic, copy) void (^onRowSelected)(NSIndexPath *indexPath,FATableViewDynamicItem *item);

+ (instancetype)itemWithModel:(id)model;

+ (instancetype)itemWithModel:(id)model height:(CGFloat)height;

+ (instancetype)itemWithModel:(id)model height:(CGFloat)height cellIdentifier:(NSString *)cellIdentifier;

- (id)objectForKeyedSubscript:(id <NSCopying>)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

@end
