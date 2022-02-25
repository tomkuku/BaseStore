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
    
    // MARK: Saving
    
    func test_savingPassword() {
        let password = "2uQfXt5fMmazZQuRujXM"
        let account = "account_12"
        
        assertNotThrows(try sut.save(passwordData: password.data(using: .utf8)!, account: account))
    }
    
    func test_savingDuplicatedPassword() {
        var password = "2uQfXt5fMmazZQuRujXM"
        var passwordData = password.data(using: .utf8)!
        let account = "account_12"
        
        assertNotThrows(try sut.save(passwordData: passwordData, account: account))
        
        password = "kUf5JgYUmfLJ9bYJBGEqn"
        passwordData = password.data(using: .utf8)!
        
        assertThrows(try sut.save(passwordData: passwordData, account: account), KeychainError.duplicateItem)
    }
    
    // MARK: Reading
    
    func test_readingNotSavedPassword() {
        let account = "account_12"
        
        assertThrows(try sut.readPasswordData(forAccount: account), KeychainError.itemNotFound)
    }
    
    func test_readingSavedPassword() {
        let password = "2uQfXt5fMmazZQuRujXM"
        let account = "account_12"
        
        assertNotThrows(try sut.save(passwordData: password.data(using: .utf8)!, account: account))
        
        var readPasswordData: Data?
        
        assertNotThrows(readPasswordData = try sut.readPasswordData(forAccount: account))
        
        let readPassword = String(data: readPasswordData ?? Data(), encoding: .utf8)
        
        assertThat(readPassword, equalTo(readPassword))
    }
    
    // MARK: Updating
    
    func test_updateNotSavedPassword() {
        let passwordData = "2uQfXt5fMmazZQuRujXM".data(using: .utf8)!
        let account = "account_12"
        
        assertThrows(try sut.update(passwordData: passwordData, forAccount: account), KeychainError.itemNotFound)
    }
    
    func test_updateSavedPassword() {
        var password = "2uQfXt5fMmazZQuRujXM"
        let account = "account_12"
        
        assertNotThrows(try sut.save(passwordData: password.data(using: .utf8)!, account: account))
        
        password = "kUf5JgYUmfLJ9bYJBGEqn"
        
        assertNotThrows(try sut.update(passwordData: password.data(using: .utf8)!, forAccount: account))
        
        var readPasswordData: Data?
        
        assertNotThrows(readPasswordData = try sut.readPasswordData(forAccount: account))
        
        let readPassword = String(data: readPasswordData ?? Data(), encoding: .utf8)
        
        assertThat(readPassword, equalTo(password))
    }
    
    // MARK: Deleting
    
    func test_deleteNotSavedPassword() {
        let account = "account_12"

        assertThrows(try sut.deletePassword(forAccount: account), KeychainError.itemNotFound)
    }
    
    func test_deleteSavedPassword() {
        let password = "2uQfXt5fMmazZQuRujXM"
        let account = "account_12"
        
        assertNotThrows(try sut.save(passwordData: password.data(using: .utf8)!, account: account))
        
        assertNotThrows(try sut.deletePassword(forAccount: account))
        
        assertThrows(try sut.readPasswordData(forAccount: account), KeychainError.itemNotFound)
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
