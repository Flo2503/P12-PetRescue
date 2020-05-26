//
//  PetRescueTests.swift
//  PetRescueTests
//
//  Created by Flo on 23/04/2020.
//  Copyright © 2020 Flo. All rights reserved.
//

import XCTest
@testable import PetRescue

class PetRescueTests: XCTestCase {

    func testGivenEmptyValue_WhenAddedValidEmail_ThenReturnTrue() {
        let validEmail =  "test.test@test.fr"

        let value = InputValuesManager.isValidEmailAddress(emailAddressString: validEmail)

        XCTAssertTrue(value)
    }

    func testGivenEmptyValue_WhenAddedWrongEmail_ThenReturnFalse() {
        let invalidEmail =  "test.test@test."

        let value = InputValuesManager.isValidEmailAddress(emailAddressString: invalidEmail)

        XCTAssertFalse(value)
    }

    func testGivenEmptyValue_WhenAddedIdenticalPasswords_ThenReturnTrue() {
        let password = "pastaBoxDu77"
        let samePassword = "pastaBoxDu77"

        let value = InputValuesManager.passwordsAreEquals(passwordOne: password, passwordTwo: samePassword)

        XCTAssertTrue(value)
    }

    func testGivenEmptyValue_WhenAddedDifferentPasswords_ThenReturnFalse() {
        let password = "pastaBoxDu77"
        let sndPassword = "pastaBoxDu02"

        let value = InputValuesManager.passwordsAreEquals(passwordOne: password, passwordTwo: sndPassword)

        XCTAssertFalse(value)
    }

    func testGivenEmptyValue_WhenAddedValidPassword_ThenReturnTrue() {
        let validPassword = "pastaBoxDu77"

        let value = InputValuesManager.isValidPassword(password: validPassword)

        XCTAssertTrue(value)
    }

    func testGivenEmptyValue_WhenAddedInvalidPassword_ThenReturnFalse() {
        let invalidPassword = "pastaBox"

        let value = InputValuesManager.isValidPassword(password: invalidPassword)

        XCTAssertFalse(value)
    }

    func testGiven_WhenAskRandomStringLength10_ThenReturnStringLength10() {
        let expected = 10

        let value = InputValuesManager.randomString(length: 10).count

        XCTAssertEqual(expected, value)
    }
}
