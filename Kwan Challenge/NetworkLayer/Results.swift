//
//  Result.swift
//  participante
//
//  Created by Marcos Felipe Souza on 26/04/19.
//  Copyright © 2019 ISP. All rights reserved.
//

import Foundation

struct Results {
    var data: Data?
    var response: Response?
    var error: Error?
    
    init(withData data: Data?, response: Response?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    init(withError error: Error) {
        self.error = error
    }
}
