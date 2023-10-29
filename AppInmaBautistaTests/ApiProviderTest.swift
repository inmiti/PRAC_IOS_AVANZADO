//
//  ApiProviderTest.swift
//  AppInmaBautistaTests
//
//  Created by ibautista on 28/10/23.
//

import XCTest
@testable import AppInmaBautista

final class ApiProviderTest: XCTestCase {
    private var sut: ApiProviderProtocol!
    
    override func setUp() {
        super.setUp()
        sut = MockApiService()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_givenApiProvider_whenDoLogin_thenGetValidToken() throws {
        let expectation = self.expectation(description: "Fetch token")
        
        sut.login(email: "inmabauvel@gmail.com", password: "a1b2c3d4") { token in
            XCTAssertNotNil(token)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_givenApiProvider_whenGetAllHeroes_thenHeroesExists() throws {
        let expectation = self.expectation(description: "Fetch heroes")
        
        sut.getHeroes(token: nil) { result in
            switch result {
            case .success(let heroes):
                XCTAssertEqual(heroes.count, 3)
            case .failure(let error):
                XCTFail("Error: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
