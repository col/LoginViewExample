//
//  MainViewController.m
//  LoginViewExample
//
//  Created by Colin Harris on 28/02/2012.
//  Copyright (c) 2012 Colin Harris. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"

@interface MainViewController ()
- (void)displayLoginView:(BOOL)animated;
- (void)logout;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Add logout button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    
    // If not already logged in, display login view
    [self displayLoginView:NO];
}

- (void)logout
{
    [self displayLoginView:YES];
}

- (void)displayLoginView:(BOOL)animated
{
    LoginViewController *loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self presentModalViewController:loginController animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
