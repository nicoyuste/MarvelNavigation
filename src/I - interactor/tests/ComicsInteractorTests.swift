//
//  ComicsViewModelMapperTests.swift
//  Marvel-NavigatorTests
//
//  Created by Nicolas Yuste on 20/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import XCTest
@testable import Marvel_Navigator


class ComicsInteractorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelsCountResponse() {
        let response = getAPIComicResponse()
        let interactor = ComicsInteractor()
        let viewModels = interactor.viewModelsFromAPIResponse(response: response)
        XCTAssert(viewModels!.count == 2, "The number of viewm Models is not correct")
    }
    
    func testViewModelMapping() {
        let response = getAPIComicResponse()
        let interactor = ComicsInteractor()
        let viewModels = interactor.viewModelsFromAPIResponse(response: response)
        let viewModel = viewModels![0]
        XCTAssert(viewModel.id == "323", "ComicsViewModelMapper is mapping the ids wrongly")
        XCTAssert(viewModel.name == "Ant-Man (2003) #2", "ComicsViewModelMapper is mapping the name wrongly")
        XCTAssert(viewModel.imageUrl == "http://i.annihil.us/u/prod/marvel/i/mg/f/20/4bc69f33cafc0.jpg", "ComicsViewModelMapper is mapping the imageUrl wrongly")
        XCTAssert(viewModel.description == "Ant-Man digs deeper to find out who is leaking secret information that threatens our national security.\r\n32 pgs./PARENTAL ADVISORY...$2.99", "ComicsViewModelMapper is mapping the description wrongly")
    }
    
    private func getAPIComicResponse() -> MarvelDataResponse {
        guard let path = Bundle.main.path(forResource: "comics", ofType: "json") else {
            XCTFail("Comics JSON File is not in the bundle")
            return MarvelDataResponse(jsonDic: [:])
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            guard let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else {
                XCTFail("Error while loading the comics JSON file")
                return MarvelDataResponse(jsonDic: [:])
            }
            return MarvelDataResponse(jsonDic: jsonResult)
        } catch {
            XCTFail("Error while loading the comics JSON file")
            return MarvelDataResponse(jsonDic: [:])
        }
    }
}
