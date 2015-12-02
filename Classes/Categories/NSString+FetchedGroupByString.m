//
//  NSString+FetchedGroupByString.m
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 1/3/13.
//  Copyright (c) 2013 Rasmus Kildevæld. All rights reserved.
//

#import "NSString+FetchedGroupByString.h"

@implementation NSString (FetchedGroupByString)
- (NSString *)stringGroupByFirstInitial {
    NSString *temp = [self uppercaseString];
    if (!temp.length || temp.length == 1)
        return self;
    return [temp substringToIndex:1];
}

@end
