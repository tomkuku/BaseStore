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
    
    private var keychainManager: KeychainManager!
    private var sut: SecureStore<SecureTestTestKey>!
    
    override func setUp() {
        super.setUp()
        
        keychainManager = KeychainManager()
        sut = SecureStore(keychainManager: KeychainManager())
    }
    
    override func tearDown() {
        do {
            try keychainManager.deletePassword(forAccount: SecureTestTestKey.testUser.key)
        } catch {
            // swiftlint:disable:next force_cast
            if error as! KeychainError != .itemNotFound {
                assertionFailure()
            }
        }
        
        super.tearDown()
    }
    
    // MARK: Tests
    
    func test_receivingNotSetValue() {
        let recievedUser: UserTest? = sut.recieve(forKey: .testUser)
        
        assertThat(recievedUser, equalTo(nil))
    }
    
    func test_receivingSetValue() {
        let user = UserTest(name: "John", surname: "Smith", age: 27, isMale: true)
        
        sut.set(value: user, forKey: .testUser)
        
        let recievedUser: UserTest? = sut.recieve(forKey: .testUser)
        
        assertThat(recievedUser, equalTo(user))
    }
    
    func test_updateValue() {
        var user = UserTest(name: "John", surname: "Smith", age: 27, isMale: true)
        
        sut.set(value: user, forKey: .testUser)
        
        user = UserTest(name: "Ashly", surname: "Burch", age: 33, isMale: false)
        
        sut.set(value: user, forKey: .testUser)
        
        let recievedUser: UserTest? = sut.recieve(forKey: .testUser)
        
        assertThat(recievedUser, equalTo(user))
    }
    
    func test_removingNotSetValue() {
        sut.remove(forKey: .testUser)

        let recievedUser: UserTest? = sut.recieve(forKey: .testUser)

        assertThat(recievedUser, equalTo(nil))
    }
    
    func test_removingSetValue() {
        let user = UserTest(name: "John", surname: "Smith", age: 27, isMale: true)

        sut.set(value: user, forKey: .testUser)

        sut.remove(forKey: .testUser)

        let recievedUser: UserTest? = sut.recieve(forKey: .testUser)

        assertThat(recievedUser, equalTo(nil))
    }
}
