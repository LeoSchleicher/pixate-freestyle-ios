//
//  PixateFreestyleViewController.m
//  PixateFreestyleShowcase
//
//  Copyright 2013 Pixate, Inc.
//  Licensed under the MIT License
//

#import "PixateFreestyleViewController.h"
#import "PixateFreestyle.h"
#import "PXStylesheetParser.h"
#import "PXMediaGroup.h"
#import "PXStyleUtils.h"

@interface PixateFreestyleViewController ()

@end

@implementation PixateFreestyleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    PXStylesheetParser *parser = [PXStylesheetParser new];
//    PXStylesheet *styleSheet = [parser parse:@"view label, view button {}"
//                                  withOrigin:PXStylesheetOriginUser];
//    
//    PXRuleSet *mergedRuleSet = [PXRuleSet ruleSetWithMergedRuleSets:[[styleSheet activeMediaGroup] ruleSets]];
//    
//    BOOL matches = [mergedRuleSet matches:[[PixateFreestyle selectFromStyleable:self.view
//                                                                  usingSelector:@"label"] objectAtIndex:8]];
//    
//    NSArray *array = [PixateFreestyle selectFromStyleable:self.view usingSelector:@"view > label"];
    
    NSArray *res = [PixateFreestyle selectFromStyleable:self.view usingSelector:@"scroll-view>view>view>label"];
    
    NSLog(@"%@", res);
}

- (NSArray *)selectUsingSelector:(NSString *)source {
    return [self selectFromStyleable:self.view usingSelector:source];
}

- (NSArray *)selectFromStyleable:(id<PXStyleable>)styleable usingSelector:(NSString *)source
{
    PXStylesheetParser *parser = [PXStylesheetParser new];
    PXStylesheet *styleSheet = [parser parse:[NSString stringWithFormat:@"%@ {}", source]
                                  withOrigin:PXStylesheetOriginUser];
    PXRuleSet *mergedRuleSet = [PXRuleSet ruleSetWithMergedRuleSets:[[styleSheet activeMediaGroup] ruleSets]];
    
    NSMutableArray *result;
    if (source && parser.errors.count == 0)
    {
        result = [NSMutableArray array];
        
        [PXStyleUtils enumerateStyleableAndDescendants:styleable usingBlock:^(id<PXStyleable> obj, BOOL *stop, BOOL *stopDescending) {
            if ([mergedRuleSet matches:obj])
            {
                [result addObject:obj];
            }
        }];
    }
    return result;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // enable scrolling in the scrollView
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size ;
    
    // place the scrollView in the proper position
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGFloat width = screenBound.size.width;
    CGFloat tabBarHeight = [[self.tabBarController tabBar] frame].size.height;
    CGFloat navBarHeight = [[self.navigationController navigationBar] frame].size.height;
    CGFloat height = screenBound.size.height - tabBarHeight - navBarHeight;
    self.scrollView.frame = CGRectMake(0, 0, width, height);
}

@end
