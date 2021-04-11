//
//  Header.swift
//  
//
//  Created by Talaxy on 2021/4/11.
//

import SwiftUI

extension Markdown {
    
    public static let headerRegex = #"^ *#{1,6} +[^ \n]+.*$"#
    public static let headerSignRegex = #"^ *#{1,6} +"#
    
    public class HeaderSplitRule: SplitRule {
        public override func split(from text: String) -> [Raw] {
            return split(by: headerRegex, text: text, type: TypeMap.header)
        }
    }
    
    public class HeaderMapRule: MapRule {
        public override func map(from raw: Raw, resolver: Resolver?) -> Element? {
            return raw.type == TypeMap.header ? HeaderElement(raw: raw) : nil
        }
    }
    
    public class HeaderElement: Element {
        public let title: String
        public let level: Int
        
        public override init(raw: Raw, resolver: Resolver? = nil) {
            if let level = raw.text.matchResult(by: headerSignRegex, options: lineRegexOption).first?.trimmed().count {
                self.level = (level >= 1 && level <= 6) ? level : 1
            } else {
                self.level = 1
            }
            title = raw.text.replace(by: headerSignRegex, with: "", options: lineRegexOption).trimmed()

            super.init(raw: raw)
        }
        
    }
    
    public struct Header: View {
        public let element: HeaderElement
        
        public init(element: HeaderElement) {
            self.element = element
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(element.title)
                    .font(.system(size: CGFloat(31 - 2 * element.level)))
                    .bold()
                    .padding(.vertical, 3)
                
                Rectangle()
                    .frame(height: CGFloat(1.8 - Double(element.level) * 0.2))
                    .border(Color.gray, width: 1)
            }
        }
    }
    
}
