//
//  ViewController.m
//  ZTestAppDemo
//
//  Created by Zaki P Laliwala on 22/08/17.
//  Copyright © 2017 Zaki P Laliwala. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[DBSession sharedSession] isLinked])
    {
        DetailViewController * detailObj = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        [self.navigationController pushViewController:detailObj animated:YES];
    }

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clk_login:(id)sender {
    if (![[DBSession sharedSession] isLinked])
    {
        [[DBSession sharedSession] linkFromController:self];
    }
    else
    {
        DetailViewController * detailObj = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        [self.navigationController pushViewController:detailObj animated:YES];
    }

}



@end
