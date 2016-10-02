//
//  CharacterInfoParser.m
//  RagialAlarm2.0
//
//  Created by Jimmy Ko on 2016-09-23.
//  Copyright © 2016 mrjko. All rights reserved.
//

#import "CharacterInfoParser.h"
#import "TFHpple.h"

@implementation CharacterInfoParser

-(instancetype) init:(NSString *)character andServer:(NSString *)server{
    self.character_name = character;
    self.server_name = server;
    self.character_url = [self getCharacterURL];
    
    @try {
        
        NSURL *url = [NSURL URLWithString:self.character_url];
        
        NSData *data = [NSData dataWithContentsOfURL:url];

        TFHpple *parser = [TFHpple hppleWithHTMLData:data];
        
        NSString *XpathQueryString = @"//a[@class='ragial']";
        NSArray *nodes = [parser searchWithXPathQuery:XpathQueryString];

        TFHppleElement *node = [nodes objectAtIndex:0];
        
        self.vending_url = [node objectForKey:@"href"];
        
      //  NSLog(@"url: %@", self.vending_url);
    }
    
    @catch (NSException *exception){
        NSLog(@"Could not find a shop open");
    }
    
    return self;
}

-(NSString*) getVendingURL{
    return self.vending_url;
}

-(NSString*) getCharacterURL {
    NSString* str;
    
    self.character_name = [self.character_name stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    if ([self.server_name isEqualToString:@"Renewal"]){
        str = [NSString stringWithFormat:@"http://ropd.info/?name=%@&s=7", self.character_name];
    } else if ([self.server_name isEqualToString:@"Classic"]){
        str = [NSString stringWithFormat:@"http://ropd.info/?name=%@&s=6", self.character_name];
    } else {
        str = [NSString stringWithFormat:@"http://ropd.info/?name=%@&s=8", self.character_name];
    }
    
    return str;
}

@end


