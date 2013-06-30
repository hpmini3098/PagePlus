//
//  PagePlusView.h
//  PagePlusSample
//
//  Created by Derek on 6/8/13.
//  Copyright (c) 2013 Derek. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AdditionView:UIView{
    UILabel *_titleLabel;
}
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) BOOL isDone;
@end

@protocol PagesDelegate <NSObject>
@required
- (void)pageChanged:(int)index;
@optional
- (void)pullLeftWillComplete:(id)sender;
- (void)pullRightWillComplete:(id)sender;
- (void)pullLeftDidComplete:(id)sender;
- (void)pullRightDidComplete:(id)sender;
@end
typedef enum PullFlag:NSUInteger{
    PullFlagNone = 0,
    PullFlagLeft,
    PullFlagRight
} PullFlag;
@interface Pages : NSObject <UIScrollViewDelegate>{
    NSMutableArray *_views;
    PullFlag _pullFlag;
}
@property(nonatomic, strong) UIScrollView *pagesView;
@property(nonatomic, assign) CGRect bounds;
@property(nonatomic, assign) int currentPage;
@property(nonatomic, assign) id<PagesDelegate> delegate;
@property(nonatomic, strong) AdditionView *leftView;
@property(nonatomic, strong) AdditionView *rightView;

- (id)initWithFrame:(CGRect)frame;

- (void)addPages:(NSArray *)views;
- (void)addPage:(UIView *)view;
- (void)insertPage:(UIView *)view atIndex:(int)index;

@end

