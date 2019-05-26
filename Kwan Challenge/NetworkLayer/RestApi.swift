//
//  RestApi.swift
//  participante
//
//  Created by Marcos Felipe Souza on 26/04/19.
//  Copyright © 2019 ISP. All rights reserved.
//

import Foundation

class RestApi: NSObject {
    
    var requestHttpHeaders = RestEntity()
    var urlQueryParameters = RestEntity()
    var httpBodyParameters = RestEntityBody()
    
    var httpBody: Data?
    
    
    var sessionConfiguration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 30
        if #available(iOS 11.0, *) {
            configuration.waitsForConnectivity = false
        }
        return configuration
    }()
    
    func makeRequest(toURL urlString: String,
                     withHttpMethod httpMethod: HttpMethod,
                     qos: DispatchQoS.QoSClass = .default,
                     completion: @escaping (_ result: Results) -> Void) {
        
        DispatchQueue.global(qos: qos).async {
            
            guard let url = URL(string: urlString) else {return}
            let targetURL = self.addURLQueryParameters(toURL: url)
            self.prepareRequestHttpHeaders(httpMethod)
            
            let httpBody = self.getHttpBody()
            guard let request = self.prepareRequest(withURL: targetURL, httpBody: httpBody, httpMethod: httpMethod) else
            {
                completion(Results(withError: CustomErrorAPI.failedToCreateRequest))
                return
            }
            let session =  URLSession(configuration: self.sessionConfiguration, delegate: self, delegateQueue: nil)
            
            session.dataTask(with: request) { (data, response, error) in
                
                if let error = error, error.isConnectivityError {
                    completion(Results(withError: CustomErrorAPI.timeOut))
                    return
                }
                
                
                completion(Results(withData: data,
                                   response: Response(fromURLResponse: response),
                                   error: error))
            }.resume()
        }
        
    }
    
    func getData(fromURL url: URL, completion: @escaping (_ data: Data?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let session = URLSession(configuration: self.sessionConfiguration)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let data = data else { completion(nil); return }
                completion(data)
            })
            task.resume()
        }
    }
    
    private func prepareRequestHttpHeaders(_ httpMethod: HttpMethod) {
        
        //By Method POST
        switch httpMethod {
        case .post(let type):
            self.requestHttpHeaders.add(value: type.rawValue, forKey: "Content-Type")        
        default:
            break
        }
    }
    
    private func addURLQueryParameters(toURL url: URL) -> URL {
        if urlQueryParameters.totalItems() > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
            
            var queryItems = [URLQueryItem]()
            for (key, value) in urlQueryParameters.allValues() {
                let item = URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                queryItems.append(item)
            }
            urlComponents.queryItems = queryItems
            
            guard let updatedURL = urlComponents.url else { return url }
            return updatedURL
        }
        
        return url
    }
    
    private func getHttpBody() -> Data? {
        guard let contentType = requestHttpHeaders.value(forKey: "Content-Type") else { return nil }
        
        if contentType.contains("application/json") {
            let result = try? JSONSerialization.data(withJSONObject: httpBodyParameters.allValues(), options: [.prettyPrinted])
            return result
            
        } else if contentType.contains("application/x-www-form-urlencoded") {
            let bodyString = httpBodyParameters.allValues().map {
                "\($0)=\(String(describing: "\($1)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))"
                }.joined(separator: "&")
            return bodyString.data(using: .utf8)
            
        } else {
            return httpBody
        }
    }
    
    private func prepareRequest(withURL url: URL?, httpBody: Data?, httpMethod: HttpMethod) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        for (header, value) in requestHttpHeaders.allValues() {
            request.setValue(value, forHTTPHeaderField: header)
        }
    
        if let httpBody = httpBody {
            request.httpBody = httpBody
        }
        return request
    }
    
}


extension RestApi: URLSessionDelegate {
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard challenge.previousFailureCount == 0 else {
            challenge.sender?.cancel(challenge)
            // Inform the user that the user name and password are incorrect
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Within your authentication handler delegate method, you should check to see if the challenge protection space has an authentication type of NSURLAuthenticationMethodServerTrust
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
            // and if so, obtain the serverTrust information from that protection space.
            && challenge.protectionSpace.serverTrust != nil
            && (challenge.protectionSpace.host == API.Info.domain ){
            let proposedCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, proposedCredential)
        }
    }
}

extension Error {
    
    var isConnectivityError: Bool {
        // let code = self._code || Can safely bridged to NSError, avoid using _ members
        let code = (self as NSError).code
        
        if (code == NSURLErrorTimedOut) {
            return true // time-out
        }
        
        if (self._domain != NSURLErrorDomain) {
            return false // Cannot be a NSURLConnection error
        }
        
        switch (code) {
        case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost, NSURLErrorCannotConnectToHost:
            return true
        default:
            return false
        }
    }
    
}
