//
//  KDYWeChatTests.swift
//  KDYWeChatTests
//
//  Created by kaideyi on 16/9/8.
//  Copyright © 2016年 kaideyi.com. All rights reserved.
//

import XCTest
@testable import KDYWeChat

class KDYWeChatTests: XCTestCase {
    
    var loginController: KDLoginViewController?
    
    override func setUp() {
        super.setUp()
        
        // 初始化的代码，在测试方法调用之前调用
        self.loginController = KDLoginViewController(nibName: "KDLoginViewController", bundle: nil)
    }
    
    override func tearDown() {
        // 释放测试用例的资源代码，这个方法会每个测试用例执行后调用
        self.loginController = nil
        
        super.tearDown()
    }
    
    func testExample() {
        // 测试用例的例子，注意测试用例一定要test开头
        let result = self.loginController?.getNumber()
        XCTAssertEqual(result, 100, "通过")
    }
    
    func testPerformanceExample() {
        // 测试性能例子
        
        self.measure {
            // 需要测试性能的代码
            for i in 0..<100 {
                print(i)
            }
        }
    }
}

