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
        
        XCTAssertEqual(currentIcon?.label, "Default")
        XCTAssertEqual(currentIcon?.iconName, "DefaultIcon")
    }
    
    func testDefinedIcons() {
        let icons = AppIcon.defined
        
        XCTAssertTrue(icons.contains { $0.label == "Default" && $0.iconName == "DefaultIcon" })
        XCTAssertTrue(icons.contains { $0.label == "Alternate Dark" && $0.iconName == "AppIcon-Alternate-Dark" })
        XCTAssertTrue(icons.contains { $0.label == "Alternate Light" && $0.iconName == "AppIcon-Alternate-Light" })
    }
    
    func testSetIcon() {
        guard let icon = AppIcon.defined.first(where: { $0.iconName == "Alternate1" }) else {
            return
        }
        
        AppIcon.set(to: icon) { error in
            XCTAssertNil(error)
            XCTAssertEqual(AppIcon.current?.label, icon.label)
            XCTAssertEqual(AppIcon.current?.iconName, icon.iconName)
        }
    }
    
    func testUnsupportedIconSetting() {
        AppIcon.application = MockAppController(supportsAlternateIcons: false)
        
        guard let icon = AppIcon.defined.first(where: { $0.iconName == "Alternate1" }) else {
            return
        }
        
        AppIcon.set(to: icon) { error in
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
                    "Alternate-Dark": [
                        "CFBundleIconFiles": ["AppIcon-Alternate-Dark"]
                    ],
                    "Alternate-Light": [
                        "CFBundleIconFiles": ["AppIcon-Alternate-Light"]
                    ]
                ]
            ]
        ]
    }
}
