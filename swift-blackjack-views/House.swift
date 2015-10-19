//  House.swift

import Foundation

class House: Player {
    
    var mustHit: Bool { return handscore < 17 }
    
    override init(name: String) {
        super.init(name: name)
        tokens = 1000
    }
}

