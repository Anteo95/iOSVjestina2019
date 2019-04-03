//
//  LoginService.swift
//  iOSVjestina2019
//
//  Created by Anteo Ivankov on 03/04/2019.
//  Copyright © 2019 Anteo Ivankov. All rights reserved.
//

import Foundation

class LoginService {
    func login(urlString: String, username: String, password: String, completion:  @escaping (String?) -> Void) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let parameters: [String: String] = [
                "username": username,
                "password": password
            ]
            request.httpBody = parameters.percentEscaped().data(using: .utf8)
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonDict = json as? [String: Any], let token = jsonDict["token"] as? String {
                            completion(token)
                        } else {
                            completion(nil)
                        }
                    } catch {
                        completion(nil)
                    }
                }
            }
            dataTask.resume()
        }
    }
}




extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
