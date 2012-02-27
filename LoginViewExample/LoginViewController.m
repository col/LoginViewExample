//
//  LoginViewController.m
//
//  Created by Colin Harris on 21/02/12.
//  Copyright (c) 2012 Colin Harris. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

// Constants
static NSString* const kUsernameDefaultsKey = @"kUsernameDefaultsKey";

@interface LoginViewController()
- (void)earthquake:(UIView*)itemView;
- (void)earthquakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)startLoginProcess;
- (void)hideKeyboard;
@end

@implementation LoginViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Se the username to the last one that was used.
    usernameField.text = [[NSUserDefaults standardUserDefaults] valueForKey:kUsernameDefaultsKey];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(id)sender 
{
    [UIView animateWithDuration:0.3 animations:^{
        // Move the table view and logo up
        [tableView setFrame:CGRectMake(10,85,300,165)];
        [logoView setFrame:CGRectMake(20,20,280,60)];
    }];
}

- (void)keyboardWillHide:(id)sender 
{
    [UIView animateWithDuration:0.3 animations:^{
        // Move the table view and logo down        
        [tableView setFrame:CGRectMake(10,147,300,165)];
        [logoView setFrame:CGRectMake(20,50,280,60)];        
    }];
}

- (BOOL)validateFields 
{
    // If either field is emoty, rock the house.
    if( usernameField.text.length == 0 || passwordField.text.length == 0 ) 
    {
        [self earthquake:tableView];
        return NO;
    }
    return YES;    
}

- (IBAction)loginClicked:(id)sender 
{    
    if( ![self validateFields] ) {
        return;
    }

    if( [usernameField isFirstResponder] || [passwordField isFirstResponder] ) 
    {
        // Hide keyboard, then start login process
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHideStartLogin:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];    
        [self hideKeyboard];       
        // Wait for keyboard to be hidden before starting the login process.
    }
    else 
    {
        // Start login process now
        [self startLoginProcess];
    }    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    // When the username field is cleared, clear the password field as well.
    if( textField == usernameField ) {
        passwordField.text = @"";
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if( textField == usernameField ) 
    {
        [passwordField becomeFirstResponder];
    }
    else 
    {
        if( ![self validateFields] ) {
            return NO;
        } else {
            [self loginClicked:self];            
        }
    }    
    return YES;
}

- (void)earthquake:(UIView*)itemView
{
    CGFloat t = 2.0;
    
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, -t);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, t);
    
    itemView.transform = leftQuake;  // starting point
    
    [UIView beginAnimations:@"earthquake" context:itemView];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:5];
    [UIView setAnimationDuration:0.07];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(earthquakeEnded:finished:context:)];
    
    itemView.transform = rightQuake; // end here & auto-reverse
    
    [UIView commitAnimations];
}

- (void)earthquakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue]) 
    {
        UIView* item = (UIView *)context;
        item.transform = CGAffineTransformIdentity;
    }
}

- (void)keyboardDidHideStartLogin:(id)sender 
{   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];            
    [self startLoginProcess];
}

- (void)startLoginProcess 
{
    [SVProgressHUD showWithStatus:@"Logging In" maskType:SVProgressHUDMaskTypeGradient];
    
    // For example purposes we'll just simulate the actual login process.
    if( [passwordField.text isEqualToString:@"asdf"] ) {
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(userDidLogin:) userInfo:nil repeats:NO];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(userLoginFailed) userInfo:nil repeats:NO];
    }
}

/**
 * Sent to the delegate when the User has successfully authenticated
 */
- (void)userDidLogin:(id)user
{
    [SVProgressHUD dismissWithSuccess:@"Logged In" afterDelay:1.5];        
    
    // Persist the Username for recovery later
	[[NSUserDefaults standardUserDefaults] setObject:usernameField.text forKey:kUsernameDefaultsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    // Move to MenuView
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"LoginViewController - userDidLogin - model dismissed!");         
    }];
}

/**
 * Sent to the delegate when the User failed login for a specific reason
 */
- (void)user:(id)user didFailLoginWithError:(NSError*)error
{
    NSLog(@"didFailLoginWithError %@", error);        
    [SVProgressHUD dismissWithError:[error localizedDescription] afterDelay:1.5];
}

// Temporary for example only
- (void)userLoginFailed
{
    [SVProgressHUD dismissWithError:@"Login failed!" afterDelay:1.5];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [usernameField release];
    [passwordField release];
    [tableView release];
    [logoView release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = indexPath.row == 0 ? @"UsernameCell" : @"PasswordCell";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        if( indexPath.row == 0 ) {
            // Username 
            usernameField.frame = CGRectMake(20,7,265,31);
            [cell addSubview:usernameField];            
        } else {
            // Password
            passwordField.frame = CGRectMake(20,7,265,31);
            [cell addSubview:passwordField];                        
        }        
        
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_background.png"]];
        aTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        aTableView.separatorColor = [UIColor grayColor];
    }    
    
    return cell;
}

- (void)hideKeyboard 
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
