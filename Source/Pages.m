//
//  Pages.m
//  PagePlusSample
//
//  Created by Derek on 6/29/13.
//  Copyright (c) 2013 Derek. All rights reserved.
//

#import "Pages.h"
#import <QuartzCore/QuartzCore.h>


#pragma mark - UIView Accessor
@interface UIView (Accessor)
- (CGFloat)x;
- (void)setX:(CGFloat)newX;
- (CGFloat)y;
- (void)setY:(CGFloat)newY;
- (CGFloat)height;
- (void)setHeight:(CGFloat)newHeight;
- (CGFloat)width;
- (void)setWidth:(CGFloat)newWidth;
@end
@implementation UIView (Accessor)

- (CGFloat)x{
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)newX{
    CGRect newFrame = self.frame;
    newFrame.origin.x = newX;
    self.frame = newFrame;
}
- (CGFloat)y{
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)newY{
    CGRect newFrame = self.frame;
    newFrame.origin.x = newY;
    self.frame = newFrame;
}
- (CGFloat)height{
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)newHeight{
    CGRect newFrame = self.frame;
    newFrame.size.height = newHeight;
    self.frame = newFrame;
}

- (CGFloat)width{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)newWidth{
    CGRect newFrame = self.frame;
    newFrame.size.width = newWidth;
    self.frame = newFrame;
}

@end

#pragma mark - AdditionView
#define IMAGE_SIZE CGSizeMake(20.0,20.0)
#define MIN_APLAHA 0.1
#define MAX_APLAHA 1.0
@implementation AdditionView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE.width, IMAGE_SIZE.height)];
        
        self.imageView.center = CGPointMake(self.width/2, self.height/2);
        self.imageView.alpha = MIN_APLAHA;
        [self addSubview:self.imageView];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.y+self.imageView.height+8, self.width, 20)];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.minimumScaleFactor = 0.6;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}

- (void)setIsDone:(BOOL)isDone{
    _isDone = isDone;
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.alpha = isDone?MAX_APLAHA:MIN_APLAHA;
    }];
    
}


@end




#pragma mark - Pages
#define SLIDE_WIDTH 80.0
#define SLIDE_DONE_X 60.0
#define FRAME_OFFSET 15.0
@implementation Pages
- (id)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.container = [[UIScrollView alloc] initWithFrame:frame];
        self.container.delegate = self;
        
        self.container.backgroundColor = [UIColor darkGrayColor];
        self.container.showsVerticalScrollIndicator = NO;
        self.container.showsHorizontalScrollIndicator = NO;
        self.container.pagingEnabled = YES;
        self.container.alwaysBounceHorizontal = YES;
        _leftView = [[AdditionView alloc] initWithFrame:CGRectMake(-SLIDE_WIDTH, 0, SLIDE_WIDTH, CGRectGetHeight(self.container.frame))];
        [self.container addSubview:_leftView];
        
        _rightView = [[AdditionView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.container.frame), 0, SLIDE_WIDTH, CGRectGetHeight(self.container.frame))];
        [self.container addSubview:_rightView];
    }
    return self;
}
@end
