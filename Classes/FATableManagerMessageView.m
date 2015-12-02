//
//  FATableManagerMessageView.m
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 22/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FATableManagerMessageView.h"

@implementation FATableManagerMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 30, 10)];
        [self addSubview:self.textLabel];
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.f];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.preferredMaxLayoutWidth = 300;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.100];
    }
    return self;
}


- (void)setMessage:(NSString *)message {
    self.textLabel.text = message;
    [self.textLabel sizeToFit];
    CGRect textFrame = self.textLabel.frame;
    
    CGRect bounds = self.bounds;
    
    textFrame.origin = CGPointMake((bounds.size.width-textFrame.size.width)/2, (bounds.size.height-textFrame.size.height)/2);
    
    self.textLabel.frame = textFrame;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
