/**
* Copyright (c) 2000-present Liferay, Inc. All rights reserved.
*
* This library is free software; you can redistribute it and/or modify it under
* the terms of the GNU Lesser General Public License as published by the Free
* Software Foundation; either version 2.1 of the License, or (at your option)
* any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
* details.
*/
import XCTest


class LRSession_Storage_Tests: XCTestCase {

	override func tearDown() {
		LRSession.removeStoredCredential()

		super.tearDown()
	}

	func test_SessionFromStoredCredential_ShouldReturnNil_WhenNoCredentialIsStored() {
		let session = LRSession.sessionFromStoredCredential()

		XCTAssertNil(session)
	}

	func test_SessionFromStoredCredential_ShouldHaveValidCredential_WhenCredentialWasStored() {
		let session = LRSession(
				server:LiferayServerContext.server,
				authentication: LRBasicAuthentication(username: "user", password: "pass"))

		XCTAssertTrue(session.storeCredential(), "storeCredential() is not saving the credentials!")

		if let storedSession = LRSession.sessionFromStoredCredential() {
			XCTAssertEqual(LiferayServerContext.server, storedSession.server!)

			XCTAssertTrue(storedSession.authentication is LRBasicAuthentication)

			if let auth = storedSession.authentication as? LRBasicAuthentication {
				XCTAssertEqual("user", auth.username!)
				XCTAssertEqual("pass", auth.password!)
			}
		}
		else {
			XCTFail("sessionFromStoredCredential() should not return nil after storing the " +
					"credentials")
		}
	}

	func test_StoreCredential_ShouldReturnFalse_WhenAuthenticationIsNil() {
		let session = LRSession(
				server:LiferayServerContext.server,
				authentication: nil)

		XCTAssertFalse(session.storeCredential())
	}

	func test_RemoveStoredCredential_ShouldRemoveExistingCredential() {
		let session = LRSession(
				server:LiferayServerContext.server,
				authentication: LRBasicAuthentication(username: "user", password: "pass"))

		session.storeCredential()

		LRSession.removeStoredCredential()

		if let session = LRSession.sessionFromStoredCredential() {
			XCTFail("sessionFromStoredCredential() should return nil after removing the credential")
		}
	}
	
}