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
    enum Info {
        static var baseURL: URL {
            return URL(string: "https://" + AppConfiguration.value(for: "API_BASE_URL"))!
        }
        
        static var key: String {
            return AppConfiguration.value(for: "API_KEY")
        }
    }
}

extension API {
    enum Headers: String {
        case authorization = "Authorization"
        case ispParticipacao = "X-ISP-Participacao"
        case ispAuthorization = "X-ISP-Authorization"
        case ispDeviceHash = "X-ISP-DeviceHash"
    }
}
