//
//  TaxonomyWorkerTests.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-02.
//

import XCTest
import ZamzamKit
@testable import SwiftyPress

class TaxonomyWorkerTests: BaseTestCase, HasDependencies {
    
    private lazy var taxonomyWorker: TaxonomyWorkerType = dependencies.resolveWorker()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

extension TaxonomyWorkerTests {
    
    func testFetch() {
        let promise = expectation(description: "Terms fetch all promise")
        
        taxonomyWorker.fetch {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Terms fetch all error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(!value.isEmpty)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension TaxonomyWorkerTests {
    
    func testFetchByID() {
        let promise = expectation(description: "Terms fetch by ID promise")
        let id = 1
        
        taxonomyWorker.fetch(id: id) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Terms fetch by ID error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.id == id)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchByIDs() {
        let promise = expectation(description: "Terms fetch by IDs promise")
        let ids: Set = [1, 5, 20]
        
        taxonomyWorker.fetch(ids: ids) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Terms fetch by IDs error: \(String(describing: $0.error))")
            }
            
            let expression = value.map { $0.id }.sorted() == Array(ids).sorted()
            
            XCTAssertTrue(expression)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension TaxonomyWorkerTests {
    
    func testFetchBySlug() {
        let promise = expectation(description: "Terms fetch by slug promise")
        let slug = "category-8"
        
        taxonomyWorker.fetch(slug: slug) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Terms fetch by slug error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.slug == slug)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension TaxonomyWorkerTests {
    
    func testFetchByURL() {
        let promise = expectation(description: "Terms fetch by url promise")
        let url = "http://example.com/category/category-2"
        
        taxonomyWorker.fetch(url: url) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Terms fetch by url error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.id == 2)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchByURL2() {
        let promise = expectation(description: "Terms fetch by url 2 promise")
        let url = "http://example.com/category/category-9/?abc=123#test"
        
        taxonomyWorker.fetch(url: url) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Terms fetch by url 2 error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.id == 9)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchByURL3() {
        let promise = expectation(description: "Terms fetch by url 3 promise")
        let url = "/tag/tag-11/?abc=123#test"
        
        taxonomyWorker.fetch(url: url) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Terms fetch by url 3 error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.id == 11)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchByURL4() {
        let promise = expectation(description: "Terms fetch by url 4 promise")
        let url = "taG/tAg-22"
        
        taxonomyWorker.fetch(url: url) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Terms fetch by url 4 error: \(String(describing: $0.error))")
            }
            
            XCTAssertTrue(value.id == 22)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension TaxonomyWorkerTests {
    
    func testFetchByCategory() {
        let promise = expectation(description: "Terms fetch by category error promise")
        
        taxonomyWorker.fetch(by: .category) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Terms fetch by category error should have failed.")
            }
            
            XCTAssertTrue(value.allSatisfy { $0.taxonomy == .category })
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchByTag() {
        let promise = expectation(description: "Terms fetch by tag error promise")
        
        taxonomyWorker.fetch(by: .tag) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Terms fetch by tag error should have failed.")
            }
            
            XCTAssertTrue(value.allSatisfy { $0.taxonomy == .tag })
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

extension TaxonomyWorkerTests {
    
    func testSearch() {
        let promise = expectation(description: "Terms search promise")
        
        let request = TaxonomyModels.SearchRequest(
            query: "1",
            scope: nil
        )
        
        taxonomyWorker.search(with: request) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Terms search error: \(String(describing: $0.error))")
            }
            
            let expression = value.allSatisfy {
                $0.name.contains(request.query)
            }
            
            XCTAssertTrue(expression)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchByCategory() {
        let promise = expectation(description: "Terms search by category promise")
        
        let request = TaxonomyModels.SearchRequest(
            query: "teGory 1",
            scope: .category
        )
        
        taxonomyWorker.search(with: request) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Terms search by category error: \(String(describing: $0.error))")
            }
            
            let expression = value.allSatisfy {
                $0.name.range(of: request.query, options: .caseInsensitive) != nil
                    && $0.taxonomy == request.scope
            }
            
            XCTAssertTrue(expression)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchByTag() {
        let promise = expectation(description: "Terms search by tag promise")
        
        let request = TaxonomyModels.SearchRequest(
            query: "tAG 1",
            scope: .tag
        )
        
        taxonomyWorker.search(with: request) {
            defer { promise.fulfill() }
            
            guard let value = $0.value, $0.isSuccess else {
                return XCTFail("Terms search by tag error: \(String(describing: $0.error))")
            }
            
            let expression = value.allSatisfy {
                $0.name.range(of: request.query, options: .caseInsensitive) != nil
                    && $0.taxonomy == request.scope
            }
            
            XCTAssertTrue(expression)
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
