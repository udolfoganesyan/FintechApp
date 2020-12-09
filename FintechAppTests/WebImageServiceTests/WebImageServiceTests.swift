//
//  WebImageServiceTests.swift
//  FintechAppTests
//
//  Created by Rudolf Oganesyan on 02.12.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import XCTest
@testable import FintechApp

final class WebImageServiceTests: XCTestCase {
    
    private var sut: WebImagesServiceProtocol!
    private var requestSender: MockRequestSender!
    
    override func setUp() {
        super.setUp()
        requestSender = MockRequestSender()
        sut = WebImagesService(requestSender: requestSender)
    }
    
    override func tearDown() {
        requestSender = nil
        sut = nil
        super.tearDown()
    }
    
    func testCorrectURLRequest() {
        //given
        let requestConfig = RequestsFactory.ImageSourceRequests.harryPotterConfig()
        
        //when
        sut?.fetchImageSource(theme: .harryPotter, completion: { _ in })
        
        //then
        XCTAssertNotEqual(requestSender.urlRequest, requestConfig.request.urlRequest)
    }
    
    func testCoreCalledOnce() {
        //when
        sut.fetchImageSource(theme: .peakyBlinders, completion: { _ in })
        
        //then
        XCTAssertEqual(requestSender.callsCounter, 1)
    }
    
    func testSourceFetching() {
        //given
        let promise = expectation(description: "Successful source fetch")
        var recievedResponse = false
        
        //when
        sut?.fetchImageSource(theme: .starWars, completion: { _ in
            recievedResponse = true
            promise.fulfill()
        })
        
        //then
        wait(for: [promise], timeout: 3)
        XCTAssertTrue(recievedResponse)
    }
}
