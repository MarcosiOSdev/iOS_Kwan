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
        static var baseURL: URL {
            return URL(string: AppConfiguration.value(for: "API_BASE_URL"))!
        }
        
        static var key: String {
            return AppConfiguration.value(for: "API_KEY")
        }
        
        static var domain: String {
            return AppConfiguration.value(for: "API_DOMAIN")
        }
    }
}
