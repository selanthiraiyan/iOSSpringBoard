//
//  ViewController.m
//  RearrangeMenu
//
//  Created by Sharma Elanthiraiyan on 9/2/13.
//  Copyright (c) 2013 Sharma Elanthiraiyan. All rights reserved.
//

#import "ViewController.h"
#import "GridMenuItem.h"

@interface ViewController ()

@property (retain) GridMenu *gridMenu;
@property (retain) NSMutableArray *menuItems;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.gridMenu = [[GridMenu alloc]initWithFrame:self.view.bounds];
    self.gridMenu.delegate = self;
    self.gridMenu.datasource = self;
    [self.view addSubview:self.gridMenu];
    
    self.menuItems = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i++) {
        GridMenuItem *menuItem = [[GridMenuItem alloc]initWithIndex:i];
        menuItem.title = [NSString stringWithFormat:@"Item %d", i];
        [self.menuItems addObject:menuItem];
    }
    
    [self.gridMenu reloadMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)numberOfMenuItems
{
    return [self.menuItems count];
}

- (GridMenuItem*)gridMenuItemAtIndex:(int)index
{
    return [self.menuItems objectAtIndex:index];
}

@end
