//
//  RagialAlarm2_0Tests.m
//  RagialAlarm2.0Tests
//
//  Created by Jimmy Ko on 2016-09-22.
//  Copyright © 2016 mrjko. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface RagialAlarm2_0Tests : XCTestCase

@property ViewController *vc;

@end

@implementation RagialAlarm2_0Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    _vc = [ViewController new];
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
