//
//  Pages.h
//  PagePlusSample
//
//  Created by Derek on 6/29/13.
//  Copyright (c) 2013 Derek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PullFlag : NSUInteger {
	PullFlagNone = 0,
	PullFlagLeft,
	PullFlagRight
} PullFlag;
@protocol PagesDataSource;
@protocol PagesDelegate;

@interface AdditionView : UIView {
	UILabel *_titleLabel;
}
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isDone;
@end

@interface Pages : UIViewController <UIScrollViewDelegate> {
	AdditionView *_leftView;
	AdditionView *_rightView;
	PullFlag _pullFlag;
	NSMutableArray *_pageViews;
	int _totalPageCount;
}
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) id <PagesDataSource> dataSource;
@property (nonatomic, assign) id <PagesDelegate> delegate;
@property (nonatomic, strong) UIScrollView *container;
@property (nonatomic, strong) UIView *currentView;

- (id)initWithFrame:(CGRect)frame;
- (void)reloadPages;
- (UIView *)dequeueReusableViewWithIndex:(int)index;
@end
@protocol PagesDataSource <NSObject>
- (int)numberOfPages;
- (UIView *)pages:(Pages *)page viewForindex:(int)index;
@end
@protocol PagesDelegate <NSObject>
- (void)pages:(Pages *)pages fromIndex:(int)fromIndex toIndex:(int)toIndex;
@optional
- (void)leftDidPullForPages:(Pages *)pages;
- (void)rightDidPullForPages:(Pages *)pages;
@end
