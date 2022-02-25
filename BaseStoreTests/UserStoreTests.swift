//
//  UserStoreTests.swift
//  BaseStoreTests
//
//  Created by Tomasz Kukułka on 22/02/2022.
//

import XCTest
import Hamcrest

@testable import BaseStore

private enum UserStoreTestKey: BaseStoreKey {
    case testValue
    
    var key: String {
        switch self {
        case .testValue: return "test_value"
        }
    }
}

class UserStoreTests: XCTestCase {
    
    private var mock: UserDefaults!
    private var sut: UserStore<UserStoreTestKey>!
    
    override func setUp() {
        super.setUp()
        
        let suiteName = "user-store-test-suite"
        mock = UserDefaults(suiteName: suiteName)
        mock.removePersistentDomain(forName: suiteName)
        sut = UserStore(userDefaults: mock)
    }
    
    override func tearDown() {
        mock = nil
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: Tests
    
    func test_setValue() {
        let value: Int = 71
        
        sut.set(value: value, forKey: .testValue)
    }
    
    func test_receivingNotSetValue() {
        let recievedValue: Int? = sut.recieve(forKey: .testValue)
        
        assertThat(recievedValue, equalTo(nil))
    }
    
    func test_recievingSetValue() {
        let value: Int = 71

        sut.set(value: value, forKey: .testValue)

        let recievedValue: Int? = sut.recieve(forKey: .testValue)

        assertThat(value == recievedValue)
    }

    func test_updatingAndRecievingValue() {
        var value: Int = 45

        sut.set(value: value, forKey: .testValue)

        var recievedValue: Int? = sut.recieve(forKey: .testValue)

        value = 99

        sut.set(value: value, forKey: .testValue)

        recievedValue = sut.recieve(forKey: .testValue)

        assertThat(value == recievedValue)
    }

    func test_removingValue() {
        let piValue: Int = 88

        sut.set(value: piValue, forKey: .testValue)

        sut.remove(forKey: .testValue)

        let recievedValue: Int? = sut.recieve(forKey: .testValue)

        assertThat(recievedValue, nilValue())
    }
}
