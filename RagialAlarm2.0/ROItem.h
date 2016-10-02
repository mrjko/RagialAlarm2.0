//
//  ROItem.h
//  RagialAlarm2.0
//
//  Created by Jimmy Ko on 2016-09-23.
//  Copyright © 2016 mrjko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ROItem : NSObject
@property(nonatomic, strong) NSString* item_name;
@property(nonatomic, strong) NSString* item_price;
@property(nonatomic, strong) NSString* item_quantity;

//@property(nonatomic, strong) NSString* item_link;

-(instancetype) init:(NSString*) name andPrice:(NSString*) price andQuantity:(NSString *)quantity;

@end
