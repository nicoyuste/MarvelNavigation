//
//  ComicsPresenter.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 01/08/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import UIKit

class ComicsPresenter: MarvelPresenter {
    
    convenience init(interactor: MarvelInteractor, router: MarvelNavigatorRouter) {
        self.init(title: "Comics",
                   iconName: .iosBookOutline,
                   headerImageName: "comics",
                   backgroundColor: .white,
                   cellToDisplay: "ComicListTableViewCell",
                   interactor: interactor,
                   router: router)
    }
}
