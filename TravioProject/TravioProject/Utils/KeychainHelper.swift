//
//  KeychainHelper.swift
//  TravioProject
//
//  Created by Burak Özer on 31.10.2023.
//

import Foundation

final class KeychainHelper {
    
    static let shared = KeychainHelper()
    
    init(){ }
    
    
    func getToken()->String?{
        
        let service = "com.travio"
        let account = "travio"
        guard let storedTokenData = KeychainHelper.shared.read(service: service, account: account),
              let storedToken = String(data: storedTokenData, encoding: .utf8) else{
            return "Token okunamadı veya bulunamadı."
        }
        return storedToken
    }

    func setToken(response: LoginSuccessResponse) {
        
        let userToken = response.accessToken
        let service = "com.travio"
        let account = "travio"
        KeychainHelper.shared.save((userToken?.data(using: .utf8))!, service: service, account: account)
    }
    
    
    func save(_ data:Data, service:String, account:String) {
        
        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        let status = SecItemAdd(query, nil)
        if status == errSecDuplicateItem {
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    func read(service:String,account:String)->Data? {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        var result:AnyObject?
        SecItemCopyMatching(query, &result)
        return (result as? Data)
    }
    
    
    func delete(_ service:String, account:String){
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        SecItemDelete(query)
    }
 
    func getAllKeyChainItemsOfClass(_ secClass: String) -> [String:String] {

        let query: [String: Any] = [
            kSecClass as String : secClass,
            kSecReturnData as String  : kCFBooleanTrue,
            kSecReturnAttributes as String : kCFBooleanTrue,
            kSecReturnRef as String : kCFBooleanTrue,
            kSecMatchLimit as String : kSecMatchLimitAll
        ]

        var result: AnyObject?
        let lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        var values = [String:String]()
        if lastResultCode == noErr {
            let array = result as? Array<Dictionary<String, Any>>
            for item in array! {
                if let key = item[kSecAttrAccount as String] as? String,
                    let value = item[kSecValueData as String] as? Data {
                    values[key] = String(data: value, encoding:.utf8)
                }
            }
        }
        return values
    }
}
