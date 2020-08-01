//
//  CharactersPresenter.swift
//  Marvel-Navigator
//
//  Created by Nicolas Yuste on 01/08/2020.
//  Copyright © 2020 Nicoyuste Inc. All rights reserved.
//

import UIKit

class CharactersPresenter: MarvelPresenter {

    convenience init(interactor: MarvelInteractor, router: MarvelNavigatorRouter) {
        self.init(title: "Heroes",
                   iconName: .iosPeopleOutline,
                   headerImageName: "heroes",
                   backgroundColor: UIColor(red: 0.561, green: 0.753, blue: 0.976, alpha: 1),
                   cellToDisplay: "CharacterListTableViewCell",
                   interactor: interactor,
                   router: router)
    }
}
