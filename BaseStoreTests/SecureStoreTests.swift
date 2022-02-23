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

private struct UserTest {
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
    
    func test_recievingNotSetValue() {
        let user = UserTest(name: "John", surname: "Smith", age: 27, isMale: true)
        
        let readUser: UserTest? = sut.recieve(forKey: .testUser)
        
        assertThat(readUser?.name, equalTo(user.name))
        assertThat(readUser?.surname, equalTo(user.surname))
        assertThat(readUser?.age, equalTo(user.age))
        assertThat(readUser?.isMale, equalTo(user.isMale))
    }
}
