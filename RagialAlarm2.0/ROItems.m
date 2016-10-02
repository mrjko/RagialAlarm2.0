//
//  ROItems.m
//  RagialAlarm2.0
//
//  Created by Jimmy Ko on 2016-09-23.
//  Copyright © 2016 mrjko. All rights reserved.
//

#import "ROItems.h"
#import "ROItem.h"

@implementation ROItems

-(NSMutableArray *)getROItems{
    return self.items;
}

-(void) addROItem:(ROItem*) item{
    [self.items addObject:item];
}

@end
