//
//  VendURLParser.m
//  RagialAlarm2.0
//
//  Created by Jimmy Ko on 2016-09-23.
//  Copyright © 2016 mrjko. All rights reserved.
//

#import "VendURLParser.h"
#import "TFHpple.h"

@implementation VendURLParser

-(instancetype) init:(NSString *)url_string andUserID:(id) user_ID andMerchantName:(NSString*) merchant_name{
    
    @try {
        
        [self getMerchantID:merchant_name];
        
        NSURL *url = [NSURL URLWithString:url_string];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        TFHpple *parser = [TFHpple hppleWithHTMLData:data];
        
        NSString *XpathQueryName = @"//td[@class='name']";
        NSArray *names = [parser searchWithXPathQuery:XpathQueryName];
        
        NSString *XpathQueryPrice = @"//td[@class='price nm']";
        NSArray *prices = [parser searchWithXPathQuery:XpathQueryPrice];
        
        NSString *XpathQueryAmt = @"//td[@class='amt']";
        NSArray *amounts = [parser searchWithXPathQuery:XpathQueryAmt];
        
        self.dbManager = [[DBManager alloc] initWithDatabaseFileName:@"ragialAlarmDB.sql"];
        
        [self checkIfMerchantExists:merchant_name];
        [self checkIfShopExists:merchant_name];
        [self checkIfLinkExists:user_ID andMerchantName:merchant_name];
        
        [self clearShopItems:merchant_name];
                
        NSInteger i = 0;
        while ([names objectAtIndex:i] != nil){
            NSString *name = [[names objectAtIndex:i] content];
            NSString *price = [[prices objectAtIndex:i] content];
            NSString *amt = [[amounts objectAtIndex:i] text];
            
            NSString *query = [NSString stringWithFormat:@"select * from Item where name = '%@'", name];
            [self.dbManager executeQuery:query];
            
            NSArray *res = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
            
            if ([res count] == 0){
                NSString *insert = [NSString stringWithFormat:@"insert into Item(price, name, quantity) values('%@', \"%@\", '%@')", price, name, amt];
             //   NSLog(@"The insertion query is : %@", insert);
                [self.dbManager executeQuery:insert];
                if(self.dbManager.affectedRows > 0){
                    NSLog(@"inserted new ITEM SUCCESFFULLY %@", name);
                }

            } else {
                NSLog(@"didnt add item because it already exists in db");
            }
            
            [self addToShopItems:name];
            
            // add into the Sells implementation? need to connect with other schemas
            i++;
        }

        
       // TFHppleElement *node = [nodes objectAtIndex:0];
        
        // create new ROitems
    }
    
    @catch (NSException *exception){
        NSLog(@"%@", exception);
    }
    
    return self;
}

-(void) checkIfMerchantExists:(NSString*) name{
    NSString *query = [NSString stringWithFormat:@"select merchantID from Merchant where merchantName='%@'", name];
    [self.dbManager executeQuery:query];
    NSArray *res = [self.dbManager loadDataFromDB:query];
    if ([res count] == 0){
        [self addMerchant:name];
    }
    return;
}

-(void) addMerchant:(NSString*) name{
    NSString *insert = [NSString stringWithFormat:@"insert into Merchant(merchantName) values('%@')", name];
    [self.dbManager executeQuery:insert];
    return;
}

-(void) checkIfLinkExists:(id) user_ID andMerchantName:(NSString*) merchant_name{
    NSString *query = [NSString stringWithFormat:@"select merchantID from Merchant where merchantName='%@'", merchant_name];
    [self.dbManager executeQuery:query];
    NSArray *res = [self.dbManager loadDataFromDB:query];
    id merchant_ID = [res objectAtIndex:0];
    query = [NSString stringWithFormat:@"select * from Linked_With where userID = %@ and merchantID =%@", [user_ID objectAtIndex:0], [merchant_ID objectAtIndex:0]];
    [self.dbManager executeQuery:query];
    res = [self.dbManager loadDataFromDB:query];
    if ([res count] == 0){
        [self addLink:user_ID andMerchantID: merchant_ID];
    }
    return;
}


-(void) addLink:(id) user_ID andMerchantID:(id) merchant_ID{

    NSString *insert = [NSString stringWithFormat:@"insert into Linked_With values(%@, %@)", [user_ID objectAtIndex:0], [merchant_ID objectAtIndex:0]];
    
    NSLog(@"insert link query:: %@", insert);
    [self.dbManager executeQuery:insert];

    return;
}

-(void) checkIfShopExists:(NSString*) name{
    NSString *query = [NSString stringWithFormat:@"select h.shopID from Merchant m, Has_Shop h where m.merchantName = '%@' and h.merchantID = m.merchantID", name];
    
    [self.dbManager executeQuery:query];
    
    NSArray *res = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    if ([res count] == 0){
        [self addShopToMerchant:name];
    } else {
        self.shopID = [res objectAtIndex:0];
    }
   
}

-(void) addShopToMerchant:(NSString*) name{
    NSString *insert = [NSString stringWithFormat:@"insert into Has_Shop(merchantID) select merchantID from Merchant where merchantName=\'%@\'", name];

    NSLog(@"adding shop query : %@", insert);
    [self.dbManager executeQuery:insert];
    
    NSString *query = [NSString stringWithFormat:@"select h.shopID from Has_Shop h, Merchant m where m.merchantID = h.merchantID and m.merchantName = \'%@'", name];
    
    [self.dbManager executeQuery:query];
    NSArray *res = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];

    self.shopID = [res objectAtIndex:0];

}

-(void) clearShopItems:(NSString*) merchant_name{
    NSString *delete = [NSString stringWithFormat:@"delete from Sells where shopID = %@", [self.shopID objectAtIndex:0]];
    [self.dbManager executeQuery:delete];
    if (self.dbManager.affectedRows > 0){
        NSLog(@"successfully cleared the shop items");
    }
}

-(void) addToShopItems:(NSString*) item_name{
   // NSString *insert = [NSString stringWithFormat:@"insert into Sells values(%@, itemID) where itemID = (select itemID from Item where item_name=\'%@\')", [self.shopID objectAtIndex:0], item_name];
    NSString *query = [NSString stringWithFormat:@"select itemID from Item where name=\'%@\'",item_name];
    [self.dbManager executeQuery:query];
    NSArray *res = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    NSString *insert = [NSString stringWithFormat:@"insert into Sells values(%@, %@)", [self.shopID objectAtIndex:0], [[res objectAtIndex:0] objectAtIndex:0]];
    NSLog(@"%@", insert);
    [self.dbManager executeQuery:insert];
    if (self.dbManager.affectedRows > 0){
        NSLog(@"item is now being sold in teh shop!");
    }
}

-(id) getMerchantID:(NSString*) merchant_name{
    NSString *query = [NSString stringWithFormat:@"select merchantID from Merchant where merchantName='%@'", merchant_name];
    [self.dbManager executeQuery:query];
    NSArray *res = [self.dbManager loadDataFromDB:query];
    return [res objectAtIndex:0];
}


@end
