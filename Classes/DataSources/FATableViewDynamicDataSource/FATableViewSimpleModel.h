//
//  FATableViewSimpleModel.h
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 05/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FATableViewSimpleModel : NSObject <NSCopying>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) id image;
@property (nonatomic, strong) id data;

+ (instancetype)modelWithTitle:(NSString *)title subtitle:(NSString *)subTitle image:(id)image;

+ (instancetype)modelWithTitle:(NSString *)title subtitle:(NSString *)subTitle image:(id)image data:(id)data;
@end
