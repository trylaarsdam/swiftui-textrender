//
//  File.swift
//  
//
//  Created by Talaxy on 2021/4/12.
//

import Foundation
import SwiftUI
import Splash

struct AttributedText: UIViewRepresentable {
    
    let attributedString: NSAttributedString
    
    init(_ attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        
        label.lineBreakMode = .byClipping
        label.numberOfLines = 0

        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = attributedString
    }
}

public struct Code: View {
		@Environment(\.colorScheme) var colorScheme

    let element: CodeElement
    
    public init(element: CodeElement) {
        self.element = element
    }
    
    @State var copyIcon = "doc.on.doc"
    public var body: some View {
        
         ZStack(alignment: .topTrailing) {
             ScrollView(.horizontal) {
                 VStack(alignment: .leading, spacing: 5) {
                     ForEach(element.lines, id: \.self) { line in
                         AttributedText(SyntaxHighlighter(format: AttributedStringOutputFormat(theme: .wwdc18(withFont: Splash.Font(size: UIFont.preferredFont(forTextStyle: .body).pointSize)))).highlight(line))
                     }
                 }.padding()
             }
             .frame(maxWidth: .infinity)
            .padding(.vertical)
            
             // language rect
             if let lang = element.lang {
                 HStack {
                     Text(lang)
                         .foregroundColor(.white)
                         .padding(.vertical, 8)
                         .padding(.horizontal, 12)
                     Button {
                         UIPasteboard.general.string = element.lines.joined(separator: "\n")
                         
                         withAnimation {
                             copyIcon = "checkmark"
                         }
                         DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                             withAnimation {
                                 copyIcon = "doc.on.doc"
                             }
                         }
                     } label: {
                         Image(systemName: copyIcon).foregroundColor(.white)
                     }.padding(.trailing, 12)
                 }
             }
         }
         // .background(Color(red: 246/256, green: 248/256, blue: 250/256))
         .frame(maxWidth: .infinity)
         .background(Color(red: 40/256, green: 40/256, blue: 40/256))
         .cornerRadius(10)
         .shadow(radius: 1)
     }
}
