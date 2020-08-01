//
//  SeriesPresenter.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 01/08/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import UIKit

class SeriesPresenter: MarvelPresenter {

    convenience init(interactor: MarvelInteractor, router: MarvelNavigatorRouter) {
        self.init(title: "Series",
                   iconName: .iosBrowsersOutline,
                   headerImageName: "series",
                   backgroundColor: .black,
                   cellToDisplay: "SeriesListTableViewCell",
                   interactor: interactor,
                   router: router)
    }
}
