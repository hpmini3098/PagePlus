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

- (CGFloat)x {
	return self.frame.origin.x;
}

- (void)setX:(CGFloat)newX {
	CGRect newFrame = self.frame;
	newFrame.origin.x = newX;
	self.frame = newFrame;
}

- (CGFloat)y {
	return self.frame.origin.y;
}

- (void)setY:(CGFloat)newY {
	CGRect newFrame = self.frame;
	newFrame.origin.y = newY;
	self.frame = newFrame;
}

- (CGFloat)height {
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newHeight {
	CGRect newFrame = self.frame;
	newFrame.size.height = newHeight;
	self.frame = newFrame;
}

- (CGFloat)width {
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newWidth {
	CGRect newFrame = self.frame;
	newFrame.size.width = newWidth;
	self.frame = newFrame;
}

@end

#pragma mark - AdditionView
#define IMAGE_SIZE CGSizeMake(20.0, 20.0)
#define MIN_APLAHA 0.1
#define MAX_APLAHA 1.0
@implementation AdditionView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE.width, IMAGE_SIZE.height)];
        
		self.imageView.center = CGPointMake(self.width / 2, self.height / 2);
		self.imageView.alpha = MIN_APLAHA;
		[self addSubview:self.imageView];
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageView.y + self.imageView.height + 8, self.width, 20)];
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

- (void)setTitle:(NSString *)title {
	_title = title;
	_titleLabel.text = title;
}

- (void)setIsDone:(BOOL)isDone {
	_isDone = isDone;
	[UIView animateWithDuration:0.3 animations: ^{
	    self.imageView.alpha = isDone ? MAX_APLAHA : MIN_APLAHA;
	}];
}

@end




#pragma mark - Pages
#define SLIDE_WIDTH 80.0
#define SLIDE_DONE_X 60.0
#define FRAME_OFFSET 30.0
@implementation Pages

- (id)initWithFrame:(CGRect)frame {
	self = [super init];
	if (self) {
		self.view.frame = frame;
		self.container = [[UIScrollView alloc] initWithFrame:self.view.bounds];
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
		[self.view addSubview:self.container];
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self reloadPages];
}

- (void)reloadPages {
	if (!self.dataSource) {
		return;
	}
	_totalPageCount = [self.dataSource numberOfPages];
	if (!_pageViews) {
		_pageViews = [[NSMutableArray alloc] initWithCapacity:_totalPageCount];
	}
    
	self.container.contentSize = CGSizeMake(self.container.width * _totalPageCount, self.container.height);
	[self insertPageAtIndex:self.currentIndex - 1];
	[self insertPageAtIndex:self.currentIndex];
	[self insertPageAtIndex:self.currentIndex + 1];
}

- (void)insertPageAtIndex:(int)index {
	if (!self.dataSource) {
		return;
	}
	if (index < 0 || index >= _totalPageCount) {
		return;
	}
    
    
	UIView *view = [self.dataSource pages:self viewForindex:index];
	if ([self.container.subviews containsObject:view]) {
		return;
	}
	view.frame = [self bigFrameWithIndex:index];
	[self.container addSubview:view];
	[_pageViews insertObject:view atIndex:index];
}

- (UIView *)dequeueReusableViewWithIndex:(int)index {
	UIView *view = nil;
	if (index >= 0 && index < [_pageViews count]) {
		view = [_pageViews objectAtIndex:index];
	}
	return view;
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[UIView animateWithDuration:0.25 animations: ^{
	    for (int i=0; i<[_pageViews count]; i++) {
            UIView *v = [_pageViews objectAtIndex:i];
            v.frame = [self smallFrameWithIndex:i];
            v.layer.masksToBounds = NO;
            v.layer.cornerRadius = 2; // if you like rounded corners
            v.layer.shadowOffset = CGSizeMake(2, 2);
            v.layer.shadowRadius = 2;
            v.layer.shadowOpacity = 0.5;
        }
	} completion: ^(BOOL finished) {
	}];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageWillChanged:)]) {
        [self.delegate pageWillChanged:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	float x = scrollView.contentOffset.x;
	AdditionView *slideView = x < 0 ? _leftView : _rightView;
	float absX = x > 0 ? x - scrollView.contentSize.width + scrollView.width : fabsf(x);
	if (absX > SLIDE_DONE_X) {
		slideView.isDone = YES;
		_pullFlag = x > 0 ? PullFlagRight : PullFlagLeft;
	}
	else {
		_pullFlag = PullFlagNone;
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (self.delegate) {
		switch (_pullFlag) {
			case PullFlagLeft:
				if ([self.delegate respondsToSelector:@selector(leftDidPullForPages:)]) {
					[self.delegate leftDidPullForPages:self];
				}
				break;
                
			case PullFlagRight:
				if ([self.delegate respondsToSelector:@selector(rightDidPullForPages:)]) {
					[self.delegate rightDidPullForPages:self];
				}
				break;
                
			default:
				break;
		}
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat pageWidth = scrollView.frame.size.width;
	int currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	[self pageChanged:self.currentIndex toIndex:currentIndex];
	self.currentIndex = currentIndex;
	_pullFlag = PullFlagNone;
	_leftView.isDone = NO;
	_rightView.isDone = NO;
    [UIView animateWithDuration:0.25 animations: ^{
	    for (int i=0; i<[_pageViews count]; i++) {
            UIView *v = [_pageViews objectAtIndex:i];
            v.frame = [self bigFrameWithIndex:i];
            v.layer.masksToBounds = YES;
            v.layer.cornerRadius = 0; // if you like rounded corners
            v.layer.shadowOffset = CGSizeMake(0, 0);
            v.layer.shadowRadius = 0;
            v.layer.shadowOpacity = 0.0;
        }
	} completion: ^(BOOL finished) {
	}];
}

#pragma mark - Private Methods
- (void)pageChanged:(int)fromIndex toIndex:(int)toIndex {
	if (fromIndex < 0 || toIndex < 0 || fromIndex == toIndex) {
		return;
	}
    if (self.delegate) {
        [self.delegate pages:self fromIndex:fromIndex toIndex:toIndex];
    }
	if (self.dataSource) {
		[self insertPageAtIndex:toIndex - 1];
		[self insertPageAtIndex:toIndex];
		[self insertPageAtIndex:toIndex + 1];
	}
}

- (CGRect)smallFrameWithIndex:(int)index {
	CGFloat x = self.container.width * index + FRAME_OFFSET;
	CGFloat y = FRAME_OFFSET;
	CGFloat width = self.container.width - FRAME_OFFSET * 2;
	CGFloat height = self.container.height - FRAME_OFFSET * 2;
	return CGRectMake(x, y, width, height);
}

- (CGRect)bigFrameWithIndex:(int)index {
	CGFloat x = self.container.width * index;
	return CGRectMake(x, 0.0, self.container.width, self.container.height);
}

@end
