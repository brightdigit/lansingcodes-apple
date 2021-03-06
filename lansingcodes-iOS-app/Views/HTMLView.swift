import SwiftUI
extension NSMutableAttributedString {
  /// Replace any font with the specified font (including its pointSize) while still keeping
  /// all other attributes like bold, italics, spacing, etc.
  /// See https://stackoverflow.com/questions/19921972/parsing-html-into-nsattributedtext-how-to-set-font
  func replaceFonts(with font: UIFont) {
    let baseFontDescriptor = font.fontDescriptor
    var changes = [NSRange: UIFont]()
    enumerateAttribute(.font, in: NSRange(location: 0, length: length), options: []) { foundFont, range, _ in
      if let htmlTraits = (foundFont as? UIFont)?.fontDescriptor.symbolicTraits,
        let adjustedDescriptor = baseFontDescriptor.withSymbolicTraits(htmlTraits) {
        let newFont = UIFont(descriptor: adjustedDescriptor, size: font.pointSize)
        changes[range] = newFont
      }
    }
    changes.forEach { range, newFont in
      removeAttribute(.font, range: range)
      addAttribute(.font, value: newFont, range: range)
    }
  }
}

extension String {
  var htmlToAttributedString: NSAttributedString? {
    guard let data = data(using: .utf8) else { return NSAttributedString() }
    do {
      let attrString = try NSMutableAttributedString(data: data, options: [
        .documentType: NSAttributedString.DocumentType.html,
        .characterEncoding: String.Encoding.utf8.rawValue
      ], documentAttributes: nil)
      attrString.replaceFonts(with: .systemFont(ofSize: 20.0))
      attrString.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: attrString.length))
      return attrString
    } catch {
      return NSAttributedString()
    }
  }

  var htmlToString: String {
    return htmlToAttributedString?.string ?? ""
  }
}

struct HTMLView: UIViewRepresentable {
  let text: NSAttributedString?

  let width: CGFloat
  func makeUIView(context _: UIViewRepresentableContext<HTMLView>) -> UILabel {
    let label = UILabel()

    label.lineBreakMode = .byWordWrapping
    label.attributedText = text
    label.numberOfLines = 0
    label.preferredMaxLayoutWidth = width

    label.sizeToFit()

    return label
  }

  func updateUIView(_ uiView: UILabel, context _: UIViewRepresentableContext<HTMLView>) {
    uiView.attributedText = text
    uiView.sizeToFit()
  }
}

struct HTMLView_Previews: PreviewProvider {
  static var previews: some View {
    let text = """
    It's easy to spin your wheels pounding at the keyboard, but a focus on <em>process</em> will make you orders of magnitude more effective.
    """.htmlToAttributedString
    return VStack {
      GeometryReader {
        HTMLView(text: text, width: $0.size.width)
      }
    }.background(Color.red)
  }
}
