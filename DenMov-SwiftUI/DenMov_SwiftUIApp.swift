//
//  DenMov_SwiftUIApp.swift
//  DenMov-SwiftUI
//
//  Created by DENAZMI on 10/01/25.
//

import SwiftUI

@main
struct DenMov_SwiftUIApp: App {
    var config: APIConfig = getConfig(fromPlist: "APIConfig")
    var baseRequest: NetworkRequest { NetworkRequestFactory.baseRequest() }
    var authRequest: NetworkRequest { NetworkRequestFactory.authRequest(with: config) }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(StoreFactory<MovieStore>(network: authRequest).build())
                .environmentObject(StoreFactory<CastStore>(network: authRequest).build())
        }
    }
}
