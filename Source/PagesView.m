//
//  PagePlusView.m
//  PagePlusSample
//
//  Created by Derek on 6/8/13.
//  Copyright (c) 2013 Derek. All rights reserved.
//

#import "PagesView.h"
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

@interface Pages ()
- (void)pageChanged:(int)fromIndex toIndex:(int)toIndex;
- (CGRect)smallFrameWithIndex:(int)index;
- (CGRect)bigFrameWithIndex:(int)index;
@end
@implementation Pages

- (id)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.pagesView = [[UIScrollView alloc] initWithFrame:frame];
        self.pagesView.backgroundColor = [UIColor darkGrayColor];
        self.pagesView.showsVerticalScrollIndicator = NO;
        self.pagesView.showsHorizontalScrollIndicator = NO;
        self.pagesView.pagingEnabled = YES;
        self.pagesView.delegate = self;
        self.pagesView.alwaysBounceHorizontal = YES;
        self.leftView = [[AdditionView alloc] initWithFrame:CGRectMake(-SLIDE_WIDTH, 0, SLIDE_WIDTH, CGRectGetHeight(self.pagesView.frame))];
        //_leftView.backgroundColor = [UIColor redColor];
        [self.pagesView addSubview:_leftView];
        
        self.rightView = [[AdditionView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.pagesView.frame), 0, SLIDE_WIDTH, CGRectGetHeight(self.pagesView.frame))];
        //_rightView.backgroundColor = [UIColor redColor];
        [self.pagesView addSubview:_rightView];
    }
    return self;
}

- (CGRect)getBounds{
    return self.pagesView.bounds;
}

#pragma mark - Add View
- (void)addPages:(NSArray *)views{
    for (UIView *view in views) {
        [self addPage:view];
    }
}
- (void)addPage:(UIView *)view{
    
    [self insertPage:view atIndex:[_views count]];
}
- (void)insertPage:(UIView *)view atIndex:(int)index{
    if (!_views) {
        _views = [[NSMutableArray alloc] initWithCapacity:1];
    }
    view.frame = [self smallFrameWithIndex:index];
    self.pagesView.contentSize = CGSizeMake(self.pagesView.contentSize.width+self.pagesView.width, self.pagesView.height);
    [_views insertObject:view atIndex:index];
    
    CGRect smallFrame = [self smallFrameWithIndex:index];
    if (index==_currentPage) {
        smallFrame.origin.y = self.pagesView.height;
    }
    [self.pagesView addSubview:view];
    [UIView animateWithDuration:0.25 animations:^{
        for (int i=[_views count]; i>index; i--) {
            UIView *v = [_views objectAtIndex:i];
            v.frame = [self bigFrameWithIndex:i];
        }
    } completion:^(BOOL finished) {
                

    }];
    
}
#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([_views count]==0) {
        return;
    }
    UIView *currentView = [_views objectAtIndex:self.currentPage];
    [UIView animateWithDuration:0.25 animations:^{
        currentView.frame = [self smallFrameWithIndex:self.currentPage];
    } completion:^(BOOL finished) {
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float x = scrollView.contentOffset.x;
    AdditionView *slideView = x<0?self.leftView:self.rightView;
    float absX = x>0?x-scrollView.contentSize.width+scrollView.width:fabsf(x);
    if (absX>SLIDE_DONE_X) {
        slideView.isDone = YES;
        _pullFlag = x>0?PullFlagRight:PullFlagLeft;
    }else{
        _pullFlag = PullFlagNone;
    }
    
    


}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.delegate) {
        switch (_pullFlag) {
            case PullFlagLeft:
                if ([self.delegate respondsToSelector:@selector(pullLeftWillComplete:)]) {
                    [self.delegate pullLeftWillComplete:self];
                }
                break;
            case PullFlagRight:
                if ([self.delegate respondsToSelector:@selector(pullRightWillComplete:)]) {
                    [self.delegate pullRightWillComplete:self];
                }
                break;
            default:
                break;
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self pageChanged:self.currentPage toIndex:currentPage];
    self.currentPage = currentPage;
    _pullFlag = PullFlagNone;
    _leftView.isDone = NO;
    _rightView.isDone = NO;
    if (self.delegate) {
        switch (_pullFlag) {
            case PullFlagLeft:
                if ([self.delegate respondsToSelector:@selector(pullLeftDidComplete:)]) {
                    [self.delegate pullLeftDidComplete:self];
                }
                break;
            case PullFlagRight:
                if ([self.delegate respondsToSelector:@selector(pullRightDidComplete:)]) {
                    [self.delegate pullRightDidComplete:self];
                }
                break;
            default:
                break;
        }
    }

}

#pragma mark - Private Methods
- (void)pageChanged:(int)fromIndex toIndex:(int)toIndex{
    if (fromIndex<0 || toIndex<0 || fromIndex==toIndex) {
        return;
    }
    if ([_views count]==0) {
        return;
    }
    UIView *toView = [_views objectAtIndex:toIndex];
    [UIView animateWithDuration:0.4 animations:^{
        toView.frame = [self bigFrameWithIndex:toIndex];
    } completion:^(BOOL finished) {
        if (self.delegate) {
            [self.delegate pageChanged:toIndex];
        }
    }];
}
- (CGRect)smallFrameWithIndex:(int)index{
    CGFloat x = self.pagesView.width*index + FRAME_OFFSET;
    CGFloat y = FRAME_OFFSET;
    CGFloat width = self.pagesView.width - FRAME_OFFSET * 2;
    CGFloat height = self.pagesView.height - FRAME_OFFSET * 2;
    return CGRectMake(x, y, width, height);
}
- (CGRect)bigFrameWithIndex:(int)index{
    CGFloat x = self.pagesView.width * index;
    return CGRectMake(x, 0.0, self.pagesView.width, self.pagesView.height);
}
@end


