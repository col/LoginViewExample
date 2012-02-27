//
//  LoginViewController.h
//
//  Created by Colin Harris on 21/02/12.
//  Copyright (c) 2012 Colin Harris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITableView *tableView;
    IBOutlet UIImageView *logoView;
}

- (IBAction)loginClicked:(id)sender;

@end
