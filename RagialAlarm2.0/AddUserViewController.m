//
//  AddUserViewController.m
//  RagialAlarm2.0
//
//  Created by Jimmy Ko on 2016-09-22.
//  Copyright © 2016 mrjko. All rights reserved.
//

#import "AddUserViewController.h"
#import "DBManager.h"
#import "FMDatabase.h"

@interface AddUserViewController ()

@property (nonatomic, weak)IBOutlet UITextField *username;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) FMDatabase *db;

-(IBAction)createNewUser:(id)sender;

@end

@implementation AddUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"ragialAlarmDB.sql"];
        
    self.username.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)createNewUser:(id)sender{
    
    NSString *insert = [NSString stringWithFormat:@"Insert into User(username) values(\"%@\")", self.username.text];
    
    [self.dbManager executeQuery:insert];
    
    if (self.dbManager.affectedRows != 0){
        NSLog(@"Insert success!");
        [self.navigationController popViewControllerAnimated:true];
    } else {
        NSLog(@"Problem with creating new user!");
    }
    
}

@end
