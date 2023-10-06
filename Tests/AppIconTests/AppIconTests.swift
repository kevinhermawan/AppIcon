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
    
    func testCurrentIconName() {
        XCTAssertEqual(AppIcon.current, "MockIconName")
    }
    
    func testDefinedIcons() {
        let icons = AppIcon.defined
        
        XCTAssertTrue(icons.contains { $0.name == "Default" })
        XCTAssertTrue(icons.contains { $0.name == "Alternate1" })
        XCTAssertTrue(icons.contains { $0.name == "Alternate2" })
    }
    
    func testSetIcon() {
        let iconName = "Alternate1"
        
        AppIcon.set(name: iconName) { error in
            XCTAssertNil(error)
            XCTAssertEqual(AppIcon.current, iconName)
        }
    }
    
    func testUnsupportedIconSetting() {
        AppIcon.application = MockAppController(supportsAlternateIcons: false)
        
        AppIcon.set(name: "Alternate1") { error in
            XCTAssertNotNil(error)
            XCTAssertEqual(error?.localizedDescription, "Alternate icons not supported")
        }
    }
}

class MockAppController: AppController {
    let mockSupportsAlternateIcons: Bool
    var mockAlternateIconName: String?
    
    init(supportsAlternateIcons: Bool = true, alternateIconName: String? = "MockIconName") {
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
