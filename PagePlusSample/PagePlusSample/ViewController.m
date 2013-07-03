//
//  ViewController.m
//  PagePlusSample
//
//  Created by Derek on 6/8/13.
//  Copyright (c) 2013 Derek. All rights reserved.
//

#import "ViewController.h"
@interface UIColor (plus)
+ (UIColor *)randomColor;
@end
@implementation UIColor (plus)
+ (UIColor *)randomColor {
	CGFloat hue = (arc4random() % 256 / 256.0);    //  0.0 to 1.0
	CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;    //  0.5 to 1.0, away from white
	CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;    //  0.5 to 1.0, away from black
	return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.pages = [[Pages alloc] initWithFrame:self.view.bounds];
	self.pages.delegate = self;
	self.pages.dataSource = self;
	[self.view addSubview:self.pages.view];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Pages DataSource
- (int)numberOfPages {
	return 5;
}

- (UIView *)pages:(Pages *)page viewForindex:(int)index {
	UIView *view = [page dequeueReusableViewWithIndex:index];
	if (!view) {
		view = [[UIView alloc] initWithFrame:page.view.bounds];
		view.backgroundColor = [UIColor randomColor];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
		label.font = [UIFont systemFontOfSize:18.0];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		label.center = view.center;
		label.text = [NSString stringWithFormat:@"%d", index];
		[view addSubview:label];
	}
	return view;
}

#pragma mark - PagesDelegate
- (void)pages:(Pages *)pages fromIndex:(int)fromIndex toIndex:(int)toIndex {
	NSLog(@"pages from %d chang to %d", fromIndex, toIndex);
}

@end
