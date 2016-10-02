//
//  VendURLParser.h
//  RagialAlarm2.0
//
//  Created by Jimmy Ko on 2016-09-23.
//  Copyright © 2016 mrjko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROItems.h"
#import "DBManager.h"

@interface VendURLParser : NSObject

@property(nonatomic, strong) ROItems *vendItems;
@property (nonatomic, strong) DBManager *dbManager;
@property(nonatomic) id shopID;



-(instancetype) init:(NSString*) url andUserID:(id) user_ID andMerchantName:(NSString*) merchant_name;

-(void) checkIfMerchantExists:(NSString*) name;
-(void) addMerchant:(NSString*) name;
-(id) getMerchantID:(NSString*) merchant_name;
-(void) checkIfLinkExists:(id) user_ID andMerchantName:(NSString*) merchant_name;
-(void) addLink:(id) user_ID andMerchantID:(id) merchant_ID;
-(void) checkIfShopExists:(NSString*) merchant_name;
-(void) addShopToMerchant:(NSString*) merchant_name;
-(void) clearShopItems:(NSString*) merchant_name;
-(void) addToShopItems:(NSString*) item_name;

@end
