import ProjectDescription

let project = Project(
    name: "EumShoppingMall",
    organizationName: "team-nativeLab",
    settings: .settings(base: ["SWIFT_VERSION": "5.9"]),
    targets: [
        .target(
            name: "EumShoppingMall",
            destinations: .iOS,
            product: .app,
            bundleId: "com.teamnativelab.eumshoppingmall",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "UILaunchScreen": [:],
                "UIAppFonts": ["NotoSansKR-Variable.ttf"],
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": false,
                    "UISceneConfigurations": [
                        "UIWindowSceneSessionRoleApplication": [[
                            "UISceneConfigurationName": "Default Configuration",
                            "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                        ]]
                    ]
                ]
            ]),
            resources: ["Projects/App/Resources/**"],
            buildableFolders: ["Projects/App/Sources"],
            settings: .settings(base: [
                "CODE_SIGNING_ALLOWED": "NO",
                "ASSETCATALOG_COMPILER_APPICON_NAME": ""
            ])
        ),
        .target(
            name: "EumShoppingMallTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.teamnativelab.eumshoppingmall.tests",
            deploymentTargets: .iOS("17.0"),
            buildableFolders: ["Projects/App/Tests"],
            dependencies: [.target(name: "EumShoppingMall")]
        )
    ]
)
