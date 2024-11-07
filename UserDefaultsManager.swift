//
//  UserDefaultsManager.swift
//  CoreDataDemo
//
//  Created by Apple on 07/11/24.
//

import Foundation


import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return defaultValue
            }
            let decodedValue = try? JSONDecoder().decode(T.self, from: data)
            return decodedValue ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

class UserDefaultsManager {
    @UserDefault(key: "loginResponse", defaultValue: nil)
    static var loginResponse: LoginResponse?
}

//When you receive a login response from the API, save it like this:
func saveLoginResponse(_ response: LoginResponse) {
    UserDefaultsManager.loginResponse = response
}

//To retrieve the saved login data when the app opens:

func fetchLoginResponse() -> LoginResponse? {
    return UserDefaultsManager.loginResponse
}

//Usage Example
// Assume we got this response from the API
let loginResponse = LoginResponse(token: "abc123", userID: 1, userName: "John Doe")

// Save the response
saveLoginResponse(loginResponse)

// Fetch the response when needed
if let savedLoginResponse = fetchLoginResponse() {
    print("User ID: \(savedLoginResponse.userID), User Name: \(savedLoginResponse.userName)")
}


struct LoginResponse: Codable {
    let token: String
    let userID: Int
    let userName: String
    // Add more fields as per your API response
}

