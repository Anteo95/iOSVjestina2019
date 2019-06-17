//
//  NetworkManager.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 17/06/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation
import Reachability

class NetworkManager: NSObject {
    
    var reachability: Reachability!
    
    static let shared: NetworkManager = { return NetworkManager() }()
    
    
    override init() {
        super.init()
        reachability = Reachability()!
    }
    
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.shared.reachability).connection != .none {
            completed(NetworkManager.shared)
        }
    }
    
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.shared.reachability).connection == .none {
            completed(NetworkManager.shared)
        }
    }
}
