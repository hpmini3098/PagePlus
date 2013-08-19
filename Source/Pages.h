//
//  Pages.h
//  PagePlusSample
//
//  Created by Derek on 6/29/13.
//  Copyright (c) 2013 Derek. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol PagesDataSource;
@protocol PagesDelegate;

@interface Pages : UIViewController <UIScrollViewDelegate> {
	int _totalPageCount;
}
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) id <PagesDataSource> dataSource;
@property (nonatomic, assign) id <PagesDelegate> delegate;
@property (nonatomic, strong) UIScrollView *container;

- (id)initWithFrame:(CGRect)frame;
- (void)reloadPages;
- (void)showThumbnail;
@end
@protocol PagesDataSource <NSObject>
- (int)numberOfPages;
- (UIView *)pages:(Pages *)page viewForindex:(int)index;
@end
@protocol PagesDelegate <NSObject>

- (void)pages:(Pages *)pages didSelected:(int)index;
@optional

@end
