//
//  SecureStoreTests.swift
//  BaseStoreTests
//
//  Created by Tomasz Kukułka on 23/02/2022.
//

import Foundation
import XCTest
import Hamcrest

@testable import BaseStore

private struct UserTest: Equatable {
    let name: String
    let surname: String
    let age: UInt
    let isMale: Bool
}

private enum SecureTestTestKey: BaseStoreKey {
    case testUser
    
    var key: String {
        switch self {
        case .testUser: return "test_password"
        }
    }
}

class SecureStoreTests: XCTestCase {
    
    private var sut: SecureStore<SecureTestTestKey>!
    
    override func setUp() {
        super.setUp()
        
        sut = SecureStore(keychainManager: KeychainManager())
    }
    
    override func tearDown() {
        clearKeychain()
        
        super.tearDown()
    }
    
    func test_recievingNotSetValue() {
        let recievedUser: UserTest? = sut.recieve(forKey: .testUser)
        
        assertThat(recievedUser, equalTo(nil))
    }
    
    func test_recievingSetValue() {
        let user = UserTest(name: "John", surname: "Smith", age: 27, isMale: true)
        
        sut.set(value: user, forKey: .testUser)
        
        let recievedUser: UserTest? = sut.recieve(forKey: .testUser)
        
        assertThat(recievedUser, equalTo(user))
    }
    
    func test_removingSetValue() {
        let user = UserTest(name: "John", surname: "Smith", age: 27, isMale: true)

        sut.set(value: user, forKey: .testUser)

        sut.remove(forKey: .testUser)

        let recievedUser: UserTest? = sut.recieve(forKey: .testUser)

        assertThat(recievedUser, equalTo(nil))
    }
    
    private func clearKeychain() {
        let query = [
            kSecClass: kSecClassInternetPassword,
            kSecAttrAccount: "test_password"
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            assertionFailure(); return
        }
    }
}
