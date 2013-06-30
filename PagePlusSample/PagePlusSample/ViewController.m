//
//  ViewController.m
//  PagePlusSample
//
//  Created by Derek on 6/8/13.
//  Copyright (c) 2013 Derek. All rights reserved.
//

#import "ViewController.h"
#import "PagesView.h"
@interface UIColor (plus)
+(UIColor *)randomColor;
@end
@implementation UIColor (plus)
+(UIColor *)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.pages = [[Pages alloc] initWithFrame:self.view.bounds];
    self.pages.delegate = self;
    self.pages.leftView.imageView.image = [UIImage imageNamed:@"2"];
    self.pages.leftView.title = @"lajsflkdsjafklasjfl";
    self.pages.rightView.imageView.image = [UIImage imageNamed:@"2"];
    self.pages.rightView.title = @"lsjaflkjsdlfladjfl";
    [self.view addSubview:self.pages.pagesView];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (int i=0; i<5; i++) {
        UIView *view = [[UIView alloc] initWithFrame:self.pages.bounds];
        view.backgroundColor = [UIColor randomColor];
        [self.pages addPage:view];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PagesDelegate
- (void)pageChanged:(int)index{
    NSLog(@"change to %d",index);
}
- (void)pullLeftDidComplete:(id)sender{
    NSLog(@"pull left complete");
    UIView *view = [[UIView alloc] initWithFrame:self.pages.pagesView.bounds];
    view.backgroundColor = [UIColor randomColor];
    [self.pages insertPage:view atIndex:0];
}

- (void)pullRightDidComplete:(id)sender{
    NSLog(@"pull right complete");
}

@end
