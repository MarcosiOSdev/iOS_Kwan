//
//  BaseServiceStub.swift
//  Kwan ChallengeTests
//
//  Created by Marcos Felipe Souza on 26/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation
@testable import Kwan_Challenge

class BaseServiceStub {
    
    var fakeError: CustomErrorService?
    
    var mockSuccess: Bool {
        return fakeError == nil
    }
    
    init(fakeError: CustomErrorService? = nil) {
        self.fakeError = fakeError
    }
    
}
