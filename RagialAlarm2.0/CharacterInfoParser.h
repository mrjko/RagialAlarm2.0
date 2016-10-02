//
//  CharacterInfoParser.h
//  RagialAlarm2.0
//
//  Created by Jimmy Ko on 2016-09-23.
//  Copyright © 2016 mrjko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharacterInfoParser : NSObject
@property (nonatomic, strong) NSString *character_name;
@property (nonatomic, strong) NSString *server_name;
@property (nonatomic, strong) NSString *character_url;
@property (nonatomic, strong) NSString *vending_url;

-(instancetype) init:(NSString *)character andServer:(NSString *)server;
-(NSString *) getVendingURL;

@end
