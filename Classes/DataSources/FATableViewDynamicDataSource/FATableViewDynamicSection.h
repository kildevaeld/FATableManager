//
//  FATableViewDynamicSection.h
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 05/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FATableViewDynamicItem.h"

@protocol FATableViewDynamicSectionDelegate;

@interface FATableViewDynamicSection : NSObject <NSFastEnumeration> {
    NSMutableArray *_items;
}

//@property (nonatomic, weak, readonly) NSArray *rows;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) CGFloat height;
@property (nonatomic) NSUInteger count;
@property (nonatomic, weak) id<FATableViewDynamicSectionDelegate> delegate;

+ (instancetype)sectionWithTitle:(NSString *)title;

+ (instancetype)sectionWithTitle:(NSString *)title height:(CGFloat)height;

- (FATableViewDynamicItem *)addRowWithData:(id)data;

- (FATableViewDynamicItem *)addRowWithData:(id)data height:(CGFloat)height cellIdentifier:(NSString *)cellIdentifier;

- (void)insertRow:(FATableViewDynamicItem *)row;

- (void)insertRow:(FATableViewDynamicItem *)row atIndex:(NSUInteger)index;

- (void)removeRowAtIndex:(NSUInteger)index;

- (void)removeRow:(FATableViewDynamicItem *)row;


- (id)objectAtIndexedSubscript:(NSUInteger)idx;

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

@end

@protocol FATableViewDynamicSectionDelegate <NSObject>

@optional

- (void)section:(FATableViewDynamicSection *)section willRemoveRow:(FATableViewDynamicItem *)row atIndex:(NSUInteger)index;

- (void)section:(FATableViewDynamicSection *)section didRemoveRow:(FATableViewDynamicItem *)row atIndex:(NSUInteger)index;

- (void)section:(FATableViewDynamicSection *)section willInsertRow:(FATableViewDynamicItem *)row atIndex:(NSUInteger)index;

- (void)section:(FATableViewDynamicSection *)section didInsertRow:(FATableViewDynamicItem *)row atIndex:(NSUInteger)index;

@end
