//
//  ViewController.m
//  RagialAlarm2.0
//
//  Created by Jimmy Ko on 2016-09-22.
//  Copyright © 2016 mrjko. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"
#import "UserViewController.h"

@interface ViewController ()

@property(weak, nonatomic) IBOutlet UITextField *username;
@property(strong, nonatomic) DBManager *dbManager;
@property(strong, nonatomic) NSString *logged_in_user;

-(IBAction) addNewUser:(id)sender;
-(IBAction) userLogIn:(id)sender;
-(IBAction) guestLogIn:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"ragialAlarmDB.sql"];
    
    self.logged_in_user = nil;
    self.username.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addNewUser:(id)sender{
    [self performSegueWithIdentifier:@"idSegueNewUserView" sender:self];
}

-(IBAction)userLogIn:(id)sender{
    if ([self verifyUsername]){
        [self performSegueWithIdentifier:@"idSegueUserView" sender:self];
    } else {
        NSLog(@"No such username in the database!");
    }
}

-(IBAction)guestLogIn:(id)sender{
    [self performSegueWithIdentifier:@"idSegueGuestView" sender:self];
}

-(BOOL) verifyUsername{
    if (self.username.text == NULL)
        return false;
    NSString *query = [NSString stringWithFormat:@"Select * from User where username= \'%@\'", self.username.text];
    
    
    NSArray *res = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if ([res count] > 0){
        self.logged_in_user = self.username.text;
        return true;
    } else {
        return false;
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"idSegueUserView"]){
        UserViewController *controller = (UserViewController *)segue.destinationViewController;
        controller.logged_in_user = self.logged_in_user;
    }
}

@end
