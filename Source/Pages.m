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





#pragma mark - Pages
#define THUMBNAIL_SCALE 0.5
#define THUMBNAIL_MARGIN_WITH 20.0
@implementation Pages

- (id)initWithFrame:(CGRect)frame {
	self = [super init];
	if (self) {
		self.view.frame = frame;
		self.container = [[UIScrollView alloc] initWithFrame:self.view.bounds];
		self.container.delegate = self;
        
		self.container.backgroundColor = [UIColor clearColor];
		self.container.showsVerticalScrollIndicator = NO;
		self.container.showsHorizontalScrollIndicator = NO;
        self.container.alwaysBounceVertical = NO;
		self.container.pagingEnabled = YES;
		self.container.alwaysBounceHorizontal = YES;
        [self.view addSubview:self.container];
        
        self.currentIndex = 0;
	}
	return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadPages];
}


- (void)reloadPages {
	if (!self.dataSource) {
		return;
	}
	_totalPageCount = [self.dataSource numberOfPages];
	
    
	self.container.contentSize = CGSizeMake(self.container.width * _totalPageCount, self.container.height);
	[self insertPageAtIndex:self.currentIndex - 1];
	[self insertPageAtIndex:self.currentIndex];
	[self insertPageAtIndex:self.currentIndex + 1];
}

- (void)insertPageAtIndex:(int)index {
    if (index<0 || index>=_totalPageCount || !self.dataSource) {
        return;
    }
    CGRect rect = [self calculateNormalRectWithIndex:index];
    UIView *view = [self.dataSource pages:self viewForindex:index];
    view.frame = rect;
    [self.container addSubview:view];
}
- (void)showThumbnail{
    
    float contentHeight = self.view.height * THUMBNAIL_SCALE;
    float thumbnailWidth = self.view.width *THUMBNAIL_SCALE ;
    float contentWidth = thumbnailWidth *(_totalPageCount+2) + THUMBNAIL_MARGIN_WITH *(_totalPageCount+1);
    float y = (self.view.height - contentHeight)/2.5;
    self.container.pagingEnabled = NO;
    self.container.frame = CGRectMake(0, y, self.view.width, contentHeight);
    self.container.contentSize = CGSizeMake(contentWidth, contentHeight);
    
    
    for (int idx=0; idx<_totalPageCount; idx++) {
        CGRect rect = [self getThumbnailRectWithIndex:idx];
        UIView *view =[self.dataSource pages:self viewForindex:idx];
        view.frame= rect;
    }
    [self scrollToViewWithIndex:self.currentIndex];
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    float offsetX = scrollView.contentOffset.x;
    self.currentIndex = [self calculateIndexWithOffset:offsetX];
    [self scrollToViewWithIndex:self.currentIndex];
	if (self.delegate) {
        [self.delegate pages:self didSelected:self.currentIndex];
	}
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

#pragma mark - Private Methods
- (CGRect)calculateNormalRectWithIndex:(int)index{
    float x = index * self.view.width;
    return CGRectMake(x, 0, self.view.width, self.view.height);
}

- (CGRect)getThumbnailRectWithIndex:(int)index{
    float width = self.view.width * THUMBNAIL_SCALE;
    float height = self.view.height *THUMBNAIL_SCALE;
    float x = (index+1)*(width+THUMBNAIL_MARGIN_WITH);
    return CGRectMake(x, 0, width, height);
}

- (void)scrollToViewWithIndex:(int)index{
    UIView *view = [self.dataSource pages:self viewForindex:index];
    
    float viewX = view.frame.origin.x;
    float offsetX = viewX * (self.container.width/self.container.contentSize.width);
    self.container.contentOffset = CGPointMake(offsetX, 0);
}

- (int)calculateIndexWithOffset:(int)offsetX{
    float centerX = offsetX+self.container.width/2.0;
    float width = self.container.width * THUMBNAIL_SCALE;
    float indexf = centerX/(width+THUMBNAIL_MARGIN_WITH);
    int index = index<self.currentIndex?ceil(indexf):floor(indexf);
    
    return index;
}


@end
