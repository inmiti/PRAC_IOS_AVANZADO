//
//  AppInmaBautistaTests.swift
//  AppInmaBautistaTests
//
//  Created by ibautista on 20/10/23.
//

import XCTest
@testable import AppInmaBautista

final class SecureDataProviderTests: XCTestCase {
    
    private var sut : SecureDataProviderProtocol!
    
    override func setUp() {
        sut = SecureDataProvider()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func test_givenSecureDataProvider_whenSaveToken_thenTokenIsEqual() throws {
        let token = "a1b2c3"
        sut.saveToken(token: token)
        XCTAssertNotNil(token)
        XCTAssertEqual(token, "a1b2c3")
    }
    
    func test_givenSecureDataProvider_whenLoadToken_thenGetSotoredToken() throws {
        let token = "a1b2c3"
        sut.saveToken(token: token)
        let tokenLoaded = sut.getToken()
        
        XCTAssertEqual(token, tokenLoaded)
    }
    
    func test_givenSecureDataProvider_whenDeleteToken_thenTokenIsNul() throws {
        let token = "a1b2c3"
        sut.deleteToken()
        let tokenDeleted = sut.getToken()
        
        XCTAssertNil(tokenDeleted)
    }
    
    
}
