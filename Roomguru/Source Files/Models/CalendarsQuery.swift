//
//  CalendarsQuery.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct CalendarsQuery: Query {
    /// Query conformance
    let method: Method = .GET
    let path = "/users/me/calendarList"
    var parameters: Parameters? = Parameters(encoding: Parameters.Encoding.URL)
    let service: SecureNetworkService = GoogleCalendarService()
}
