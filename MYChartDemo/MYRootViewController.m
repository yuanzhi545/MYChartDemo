//
//  MYRootViewController.m
//  MYChartDemo
//
//  Created by yuan zhi on 7/7/14.
//  Copyright (c) 2014 yuan zhi. All rights reserved.
//

#import "MYRootViewController.h"
#import "MYPieViewController.h"
#import "MYColumnViewController.h"

@interface MYRootViewController ()

@end

@implementation MYRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"饼图";
            break;
        case 1:
            cell.textLabel.text = @"柱状图";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MYPieViewController *controller = [[MYPieViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == 1)
    {
        MYColumnViewController *controller = [[MYColumnViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
