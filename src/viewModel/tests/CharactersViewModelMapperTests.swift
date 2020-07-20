//
//  ComicsViewModelMapperTests.swift
//  Marvel-NavigatorTests
//
//  Created by Nicolas Yuste on 20/07/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import XCTest
@testable import Marvel_Navigator


class CharactersViewModelMapperTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelsCountResponse() {
        let response = getAPICharactersResponse()
        let mapper = CharactersViewModelMapper()
        let viewModels = mapper.viewModelsFromAPIResponse(response: response)
        XCTAssert(viewModels.count == 3, "The number of viewm Models is not correct")
    }
    
    func testViewModelMapping() {
        let response = getAPICharactersResponse()
        let mapper = CharactersViewModelMapper()
        let viewModels = mapper.viewModelsFromAPIResponse(response: response)
        let viewModel = viewModels[0]
        XCTAssert(viewModel.id == "1010354", "ComicsViewModelMapper is mapping the ids wrongly")
        XCTAssert(viewModel.name == "Adam Warlock", "ComicsViewModelMapper is mapping the name wrongly")
        XCTAssert(viewModel.imageUrl == "http://i.annihil.us/u/prod/marvel/i/mg/a/f0/5202887448860.jpg", "ComicsViewModelMapper is mapping the imageUrl wrongly")
        XCTAssert(viewModel.description == "Adam Warlock is an artificially created human who was born in a cocoon at a scientific complex called The Beehive.", "ComicsViewModelMapper is mapping the description wrongly")
    }
    
    private func getAPICharactersResponse() -> MarvelDataResponse {
        guard let path = Bundle.main.path(forResource: "heroes", ofType: "json") else {
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
