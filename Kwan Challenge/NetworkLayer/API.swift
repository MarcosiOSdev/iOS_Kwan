//
//  WebApi.swift
//  Kwan Challenge
//
//  Created by Marcos Felipe Souza on 23/05/19.
//  Copyright © 2019 Marcos Felipe. All rights reserved.
//

import Foundation

struct API {
}

extension API {
    struct Info {
        static var baseURL: String {
            return InfoPlist.value(for: "Backend Url")
        }
        
        static var key: String {
            return InfoPlist.value(for: "Api Key")
        }
        
        static var domain: String {
            return InfoPlist.value(for: "Api Domain")
        }
    }
}
