//
//  ROItem.m
//  RagialAlarm2.0
//
//  Created by Jimmy Ko on 2016-09-23.
//  Copyright © 2016 mrjko. All rights reserved.
//

#import "ROItem.h"

@implementation ROItem

-(instancetype) init:(NSString *)name andPrice:(NSString *)price andQuantity:(NSString *)quantity{
    self.item_name = name;
    self.item_price = price;
    self.item_quantity = quantity;
    return self;
}

-(NSString*) getName{
    return self.item_name;
}

-(NSString*) getPrice{
    return self.item_price;
}

-(NSString*) getQuantity{
    return self.item_quantity;
}

@end
