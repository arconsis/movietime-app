//
//  Dependencies.swift
//  movietime-appManifests
//
//  Created by Jonas Stubenrauch on 08.07.22.
//

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/pointfreeco/swift-composable-architecture", requirement: .exact("0.43.0")),
        .remote(url: "https://github.com/birdrides/mockingbird", requirement: .upToNextMajor(from: "0.18.1")),
        .remote(url: "https://github.com/evgenyneu/keychain-swift", requirement: .upToNextMajor(from: "20.0.0"))
    ],
    platforms: [.iOS])
