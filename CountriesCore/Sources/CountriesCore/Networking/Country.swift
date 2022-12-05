import Foundation

public struct Country: Hashable, Codable {
    public var name: NameInfo
    public var flagEmoji: String
}

public extension Country {
    struct NameInfo: Hashable, Codable {
        public var common: String
        public var official: String

        public enum CodingKeys: String, CodingKey {
            case common
            case official
        }
    }
}

public extension Country {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case flagEmoji = "flag"
    }
}

public extension Country {
    static var exmaple: Country {
        Country(name: .init(common: "United Kingdom", official: "United Kingdom of Great Britain and Northern Ireland"), flagEmoji: "🇬🇧")
    }
}
