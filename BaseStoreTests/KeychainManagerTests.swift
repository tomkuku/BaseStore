//
//  KeychainManagerTests.swift
//  BaseStoreTests
//
//  Created by Tomasz Kukułka on 23/02/2022.
//

import XCTest
import Hamcrest

@testable import BaseStore

class KeychainManagerTests: XCTestCase {
    
    private var sut: KeychainManager!
    
    override func setUp() {
        super.setUp()
        
        sut = KeychainManager()
    }
    
    override func tearDown() {
        clearKeychain()
        
        super.tearDown()
    }
    
    func test_savingPassword() {
        let password = "2uQfXt5fMmazZQuRujXM"
        let account = "account_12"
        
        do {
            try sut.save(passwordData: password.data(using: .utf8)!, account: account)
        } catch {
            XCTFail("Saving password faild with \(error.localizedDescription)!")
        }
    }
    
    private func clearKeychain() {
        let query = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrAccount: "account_12"
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            assertionFailure(); return
        }
    }
}
