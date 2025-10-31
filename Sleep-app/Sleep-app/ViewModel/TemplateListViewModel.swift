//
//  TemplateListViewModel.swift
//  Sleep-app
//
//  Created by miyamotokenshin on R 7/10/29.
//

import Foundation
import SwiftUI

final class TemplateListViewModel: ObservableObject {
    @Published var showCreate = false
    
    func onSelect(_ template: SoundTemplate,
                  using templateVM: TemplateViewModel,
                  soundVM: SoundSelectViewModel,
                  homeVM: HomeViewModel) {
        templateVM.play(template, soundVM: soundVM, homeVM: homeVM)
    }
}

