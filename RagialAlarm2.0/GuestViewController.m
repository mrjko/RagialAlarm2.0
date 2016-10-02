//
//  GuestViewController.m
//  RagialAlarm2.0
//
//  Created by Jimmy Ko on 2016-09-22.
//  Copyright © 2016 mrjko. All rights reserved.
//

#import "GuestViewController.h"
#import "CharacterInfoParser.h"
#import "VendURLParser.h"
#import "DBManager.h"
#import "FMDatabase.h"

@interface GuestViewController ()


@property(nonatomic, strong) NSString *server;
@property(nonatomic, strong) NSString *character_name;
@property(nonatomic, strong) IBOutlet UIPickerView *servers;
@property(nonatomic, strong) IBOutlet UISearchBar *search_bar;
@property(nonatomic, strong) NSMutableArray *server_options;
@property(nonatomic, strong) IBOutlet UITableView *result_table;
@property(nonatomic, strong) NSArray *merchant_items;
@property(nonatomic, strong) UIButton *search_btn;
@property(nonatomic, strong) DBManager *dbManager;
@property(nonatomic) id guest_id;
@property(nonatomic) id merchant_id;

-(IBAction) searchPlayer:(id)sender;
-(void) checkIfGuestAccountExists;
-(void) addGuestAccount;
-(void) clearAllGuestLinks;
-(void) loadVendItems;

@end

@implementation GuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.server = @"Renewal";
    self.character_name = @" ";
    self.search_bar.delegate = self;
    self.servers.layer.zPosition = 0.99;
    
    self.server_options = [[NSMutableArray alloc] initWithObjects:@"Renewal", @"Classic", @"Thor", nil];
    
    self.servers = [[UIPickerView alloc] init];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"ragialAlarmDB.sql"];
    
    [self checkIfGuestAccountExists];
    
    self.servers.delegate = self;
    self.servers.dataSource = self;
    
    self.result_table.delegate = self;
    self.result_table.dataSource = self;
    
}

-(BOOL) searchBarShouldEndEditing:(UISearchBar *)searchBar{
    self.character_name = self.search_bar.text;
    NSLog(@"self.search_bar.text: %@", self.search_bar.text);
    return true;
}

// UIPickerView Setup

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"%@", [self.server_options objectAtIndex:row]);
    self.server = [self.server_options objectAtIndex:row];
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.server_options count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.server_options objectAtIndex:row];
}

// UITableView Setup:

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.merchant_items count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idPrototypeCell"];
    
    NSLog(@"popped the prototype cell");
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"idPrototypeCell"];
    }
    NSLog(@"here");
    
    
    NSInteger indexOfItemName = [self.dbManager.arrColumnNames indexOfObject:@"name"];
    NSInteger indexOfItemPrice = [self.dbManager.arrColumnNames indexOfObject:@"price"];
    NSInteger indexOfItemQuantity = [self.dbManager.arrColumnNames indexOfObject:@"quantity"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.merchant_items objectAtIndex:indexPath.row] objectAtIndex:indexOfItemName]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  %@", [[self.merchant_items objectAtIndex:indexPath.row] objectAtIndex:indexOfItemPrice], [[self.merchant_items objectAtIndex:indexPath.row] objectAtIndex: indexOfItemQuantity]];

    return cell;
}

// UIButton Setup

-(IBAction)searchPlayer:(id)sender{
    [self.search_bar endEditing:true];
    if ([self.character_name  isEqual: @" "]){
        NSLog(@"no name in the search field");
        return;
    }
    [self clearAllGuestLinks];
    CharacterInfoParser *character_parser = [[CharacterInfoParser alloc] init:self.character_name andServer:self.server];
   // NSLog(@"the vending url is: %@", [character_parser getVendingURL]);
    VendURLParser *vend_parser = [[VendURLParser alloc] init:[character_parser getVendingURL] andUserID:self.guest_id andMerchantName:self.character_name];
    self.merchant_id = [vend_parser getMerchantID:self.character_name];
    [self loadVendItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) checkIfGuestAccountExists{
    NSString *query = @"select userID from User where userName = 'guest_account'";
    [self.dbManager executeQuery:query];
    NSArray *res = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    if ([res count] == 0){
        [self addGuestAccount];
    } else {
        self.guest_id = [res objectAtIndex:0] ;
    }
    return;
}

-(void) addGuestAccount{
    
    NSString *insert = @"Insert into User(userName) values('guest_account')";
    [self.dbManager executeQuery:insert];
    
    NSString *query = @"select userID from User where userName = 'guest_account'";
    [self.dbManager executeQuery:query];
    NSArray *res = [self.dbManager loadDataFromDB:query];
    
    self.guest_id = [res objectAtIndex:0];
    return;
    
}

-(void) clearAllGuestLinks{
    NSString *delete = [NSString stringWithFormat:@"delete from Linked_With where userID = %@", self.guest_id];
    [self.dbManager executeQuery:delete];
    return;
}

-(void) loadVendItems{
    
    NSString *query = [NSString stringWithFormat:@"select name, quantity, price from Linked_With l, Item i, Sells s, Has_shop h where l.userID=%@ and l.merchantID=%@ and h.merchantID = l.merchantID and h.shopID=s.shopID and s.itemID=i.itemID", [self.guest_id objectAtIndex:0], [self.merchant_id objectAtIndex:0]];
    
    NSLog(@"%@", query);
    
    if (self.merchant_items != nil){
        self.merchant_items = nil;
    }
    
    self.merchant_items = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    for (NSInteger i = 0; i < [self.merchant_items count] ; i++){
        NSLog(@"debugging: %@", [self.merchant_items objectAtIndex:i]);
    }
    
    [self.result_table reloadData];
    
    return;
}

@end
