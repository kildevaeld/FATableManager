//
//  FATableViewSimpleModel.m
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 05/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FATableViewSimpleModel.h"

@implementation FATableViewSimpleModel

+ (instancetype)modelWithTitle:(NSString *)title subtitle:(NSString *)subTitle image:(id)image {
    return [self modelWithTitle:title subtitle:subTitle image:image data:nil];
}

+ (instancetype)modelWithTitle:(NSString *)title subtitle:(NSString *)subTitle image:(id)image data:(id)data {
    FATableViewSimpleModel *model = [self new];
    model.title = title;
    model.subtitle = subTitle;
    model.image = image;
    model.data = data;
    return model;
}

- (id)copyWithZone:(NSZone *)zone {
    FATableViewSimpleModel *model = [FATableViewSimpleModel allocWithZone:zone];
    model.title = self.title.copy;
    model.subtitle = self.subtitle.copy;
    model.data = self.data;
    model.image = self.image;
    return model;
}




@end
