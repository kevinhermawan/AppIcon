import XCTest
@testable import AppIcon

final class AppIconTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        AppIcon.application = MockAppController()
        AppIcon.bundle = MockBundle()
    }
    
    override func tearDown() {
        AppIcon.application = AppController()
        AppIcon.bundle = .main
        
        super.tearDown()
    }
    
    func testIsSupported() {
        XCTAssertTrue(AppIcon.isSupported)
    }
    
    func testCurrentIcon() {
        let currentIcon = AppIcon.current
        
        XCTAssertEqual(currentIcon?.name, "Default")
        XCTAssertEqual(currentIcon?.imageName, "DefaultIcon")
    }
    
    func testDefinedIcons() {
        let icons = AppIcon.defined
        
        XCTAssertTrue(icons.contains { $0.name == "Default" && $0.imageName == "DefaultIcon" })
        XCTAssertTrue(icons.contains { $0.name == "Alternate1" && $0.imageName == "AlternateIcon1" })
        XCTAssertTrue(icons.contains { $0.name == "Alternate2" && $0.imageName == "AlternateIcon2" })
    }
    
    func testSetIcon() {
        guard let iconToSet = AppIcon.defined.first(where: { $0.name == "Alternate1" }) else {
            return
        }
        
        AppIcon.set(icon: iconToSet) { error in
            XCTAssertNil(error)
            XCTAssertEqual(AppIcon.current?.name, iconToSet.name)
            XCTAssertEqual(AppIcon.current?.imageName, iconToSet.imageName)
        }
    }
    
    func testUnsupportedIconSetting() {
        AppIcon.application = MockAppController(supportsAlternateIcons: false)
        
        guard let iconToSet = AppIcon.defined.first(where: { $0.name == "Alternate1" }) else {
            return
        }
        
        AppIcon.set(icon: iconToSet) { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Alternate icons not supported")
        }
    }
}

class MockAppController: AppController {
    let mockSupportsAlternateIcons: Bool
    var mockAlternateIconName: String?
    
    init(supportsAlternateIcons: Bool = true, alternateIconName: String? = nil) {
        self.mockSupportsAlternateIcons = supportsAlternateIcons
        self.mockAlternateIconName = alternateIconName
        
        super.init()
    }
    
    override var supportsAlternateIcons: Bool {
        mockSupportsAlternateIcons
    }
    
    override var alternateIconName: String? {
        mockAlternateIconName
    }
    
    override func setAlternateIconName(_ alternateIconName: String?, completionHandler: ((Error?) -> Void)?) {
        mockAlternateIconName = alternateIconName
        
        completionHandler?(nil)
    }
}

class MockBundle: Bundle {
    override var infoDictionary: [String: Any]? {
        return [
            "CFBundleIcons": [
                "CFBundlePrimaryIcon": [
                    "CFBundleIconFiles": ["DefaultIcon"]
                ],
                "CFBundleAlternateIcons": [
                    "Alternate1": [
                        "CFBundleIconFiles": ["AlternateIcon1"]
                    ],
                    "Alternate2": [
                        "CFBundleIconFiles": ["AlternateIcon2"]
                    ]
                ]
            ]
        ]
    }
}
