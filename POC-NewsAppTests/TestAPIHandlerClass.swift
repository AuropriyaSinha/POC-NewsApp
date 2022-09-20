//
//  TestAPIHandlerClass.swift
//  POC-NewsAppTests
//
//  Created by Auropriya Sinha on 20/09/22.
//

import XCTest
@testable import POC_NewsApp

class TestAPIHandlerClass: XCTestCase {

    //MARK: Test case for valid API response
    func testValidStoriesReturnsSuccess() {
        let apiHandler = APIHandler()
        let expectation = self.expectation(description: "ValidRequest_Returns_Success")
        
        apiHandler.getTopStories { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let arr) :
                XCTAssertNotNil(arr)
                XCTAssertGreaterThan(arr.count, 0)
            case .failure(let e) :
                XCTAssertNil(e)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
    //MARK: Test case with invalid url
    func testInValidStoriesReturnsFailure() {
        let apiHandler = APIHandler()
        apiHandler.topHeadLinesURL = URL(string:  "https://newsapi.org/v2/top-headlines?country=INDIA&apiKey=eda6154a62744b7bbad849130a7f7b6f")
        let expectation = self.expectation(description: "ValidRequest_Returns_Failure")
        
        apiHandler.getTopStories { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let arr) :
                XCTAssertNotNil(arr)
                XCTAssertEqual(arr.count, 0)
            case .failure(let e) :
                XCTAssertNil(e)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
    //MARK: Test case for a url without api key
    func testInValidURLReturnsFailure() {
        let apiHandler = APIHandler()
        apiHandler.topHeadLinesURL = URL(string:  "https://newsapi.org/v2/top-headlines?country=INDIA&apiKey=")
        let expectation = self.expectation(description: "InvalidURL_Returns_Failure")
        
        apiHandler.getTopStories { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let arr) :
                XCTAssertNotNil(arr)
                XCTAssertEqual(arr.count, 0)
            case .failure(let e) :
                XCTAssertNotNil(e)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
    //MARK: Test case with url using only numbers
    func testInvalidURLWithNumbersReturnsFailure() {
        let apiHandler = APIHandler()
        apiHandler.topHeadLinesURL = URL(string:  "123")
        let expectation = self.expectation(description: "InvalidURL_Returns_Failure")
        
        apiHandler.getTopStories { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let arr) :
                XCTAssertNotNil(arr)
                XCTAssertEqual(arr.count, 0)
            case .failure(let e) :
                XCTAssertNotNil(e)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
    //MARK: Test case for valid API search
    func testValidSearchReturnsSuccess() {
        let apiHandler = APIHandler()
        let expectation = self.expectation(description: "Valid_Search_URL_Success")
        
        apiHandler.search(query: "Hello") { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let arr) :
                XCTAssertNotNil(arr)
                XCTAssertGreaterThan(arr.count, 0)
            case .failure(let e) :
                XCTAssertNil(e)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
    //MARK: Test case with blank space query
    func testInvalidSearchQueryReturnsFailure() {
        let apiHandler = APIHandler()
        
        apiHandler.search(query: " ") { result in
            XCTAssertNil(result)
        }
    }
    
    //MARK: Test case with invalid url(only numbers) but valid valid query
    func testSearchWithInvalidURLReturnsFailure() {
        let apiHandler = APIHandler()
        apiHandler.searchURLString = "123"
        let expectation = self.expectation(description: "InValid_Search_URL_Failure")
        
        apiHandler.search(query: "Hello") { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let arr) :
                XCTAssertNotNil(arr)
                XCTAssertGreaterThan(arr.count, 0)
            case .failure(let e) :
                XCTAssertNotNil(e)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
    //MARK: Test case with invalid query and invalid url
    func testSearchWithInvalidURLInvalidQueryReturnsFailure() {
        let apiHandler = APIHandler()
        apiHandler.searchURLString = "123"
        let expectation = self.expectation(description: "InValid_SearchandURL_Failure")
        
        apiHandler.search(query: "9") { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let arr) :
                XCTAssertNotNil(arr)
                XCTAssertEqual(arr.count, 0)
            case .failure(let e) :
                XCTAssertNotNil(e)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }
    
    //MARK: Test case with blank search url and blank query
    func testBlankQueryBlankURLReturnsFailure() {
        let apiHandler = APIHandler()
        apiHandler.searchURLString = " "
        
        apiHandler.search(query: " ") { result in
            XCTAssertNil(result)
        }
    }
    
    //MARK: Test case with search url not having apikey
    func testInvalidURLValidQueryReturnsFailure() {
        let apiHandler = APIHandler()
        apiHandler.searchURLString = "https://newsapi.org/v2/top-headlines?country=INDIA&apiKey="
        let expectation = self.expectation(description: "InvalidSearchURL_Returns_Failure")
        
        apiHandler.search(query: "A") { result in
            XCTAssertNotNil(result)
            switch result {
            case .success(let arr) :
                XCTAssertNotNil(arr)
                XCTAssertEqual(arr.count, 0)
            case .failure(let e) :
                XCTAssertNotNil(e)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10)
    }

}
