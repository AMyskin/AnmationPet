//
//  TransliterationHelper.swift
//
//
//  Created by Сергей Тихонов on 22.05.2022.
//

import UIKit

@objc public final class TransliterationHelper: NSObject {
    static func isTransliterationNeeded(in sourceText: String) -> Bool {
        return UIAccessibility.isVoiceOverRunning &&
        isThereLatinAndCyrillic(in: sourceText)
    }

    @objc public static func transliterate(sourceText: String) -> String {
        // По дефолту кириллица. При внедрении мультиязычности здесь можно будет
        // предварительно определять язык.
        transliterate(sourceText: sourceText, transformDirection: .latinToCyrillic)
    }

    private static func isThereLatinAndCyrillic(in sourceText: String) -> Bool {
        return sourceText.range(of: "\\p{Latin}", options: .regularExpression) != nil &&
        sourceText.range(of: "\\p{Cyrillic}", options: .regularExpression) != nil
    }

    private static func transliterate(sourceText: String, transformDirection: StringTransform) -> String {
        var resultString: String = sourceText
        // Если будут нужны новые звуки для фикса транслетирации
        // Добавляем их в оба массива. В accessibilityArray то, что нужно исправить,
        // В transliterationArray то, как будет звучать
        let accessibilityArray: [String] = ["еы"]
        let transliterationArray: [String] = ["и"]
        resultString = sourceText.applyingTransform(transformDirection, reverse: false) ?? ""

        for index in 0..<transliterationArray.count {
            resultString = resultString.replacingOccurrences(
                of: accessibilityArray[index],
                with: transliterationArray[index]
            )
        }
        return resultString
    }
}
