//
//  VocalizeCurrencyLogic.swift
//  
//
//  Created by Андрей Тимоненков on 20.04.2021.
//

import Foundation

final public class VocalizeCurrency {
    private static let rubWordForms: [Int: String] = [
        0: "rubley".localized,
        1: "rubl".localized,
        2: "rublya".localized,
        3: "rublya".localized,
        4: "rublya".localized,
        5: "rubley".localized,
        6: "rubley".localized,
        7: "rubley".localized,
        8: "rubley".localized,
        9: "rubley".localized,
        10: "rubley".localized,
        11: "rubley".localized,
        12: "rubley".localized,
        13: "rubley".localized,
        14: "rubley".localized
    ]
    private static let percentWordForms: [Int: String] = [
        0: "procentov".localized,
        1: "procent".localized,
        2: "procenta".localized,
        3: "procenta".localized,
        4: "procenta".localized,
        5: "procentov".localized,
        6: "procentov".localized,
        7: "procentov".localized,
        8: "procentov".localized,
        9: "procentov".localized,
        10: "procentov".localized,
        11: "procentov".localized,
        12: "procentov".localized,
        13: "procentov".localized,
        14: "procentov".localized
    ]
    private static let defaultWordForms: [String: [Int: String]] = [
        "₽": rubWordForms,
        "руб": rubWordForms,
        "руб.": rubWordForms,
        "%": percentWordForms
    ]

    private static let numsForSum: Set<Character> = [
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ",", "."
    ]

    // MARK: - Private funcs

    /// Преобразовать символ валюты в текст
    ///
    /// - Parameters:
    ///   - symbol: Символ валюты
    ///            Пример: ```₽```, ```руб```, ```руб.```
    ///   - value: Значение для определения словоформы. Учитывается последний символ.
    ///   - wordForms: Словоформы
    ///              Для примера см.: ```VocalizeCurrency.defaultWordForms```
    private static func prepareForVocalizeCurrency(
        symbol: String,
        value: String?,
        wordForms: [String: [Int: String]]
    ) -> String {
        guard
            let currencyWordForms = wordForms[symbol],
            !currencyWordForms.isEmpty
        else {
            return symbol
        }
        guard
            let value = value,
            !value.isEmpty,
            var intValue = Int(value)
        else {
            return currencyWordForms[0] ?? symbol
        }

        intValue = abs(intValue)
        let divBy100 = intValue % 100
        if divBy100 >= 11 && divBy100 <= 14 {
            return currencyWordForms[divBy100] ?? symbol
        } else {
            let divBy10 = intValue % 10
            return currencyWordForms[divBy10] ?? symbol
        }
    }

    /// Проверяет что строка содержит только числа или символы точки/запятой.
    ///
    /// - Parameters:
    ///   - string: Строка для проверки
    private static func isNumeric(_ string: String) -> Bool {
        guard !string.isEmpty else { return false }
        return Set(string).isSubset(of: VocalizeCurrency.numsForSum)
    }

    // MARK: - Public funcs

    /// Озвучить текст с суммой.
    /// Например: "Оплата 100 ₽ в месяц" -> "Оплата сто рублей в месяц"
    ///
    /// - Parameters:
    ///   - from: Текст для озвучивания
    public static func prepareTextForVocalize(from source: String) -> String {
        var elements = source.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        for index in 0..<elements.count {
            if VocalizeCurrency.defaultWordForms.keys.contains(elements[index].lowercased()) {
                var value: String?
                if index > 0 {
                    value = elements[index - 1]
                }
                elements[index] = VocalizeCurrency.prepareForVocalizeCurrency(
                    symbol: elements[index],
                    value: value,
                    wordForms: VocalizeCurrency.defaultWordForms
                )
            }
        }

        return elements.joined(separator: " ")
    }

    /// Подготовить суммы в тексте для озвучки, удалив пробелы между цифрами.
    /// Замечание: слово считается состоящим из цифр в том случае, если оно содержит
    /// цифры от 0 до 9 и/или символы "." или "," (разделители для дробной части суммы).
    /// Например: "Сумма на счете 100 000.00 руб." -> "Сумма на счете 100000.00 руб."
    ///
    /// - Parameters:
    ///   - from: Текст для озвучивания
    public static func prepareSumForVocalize(from source: String) -> String {
        let elements = source.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        var result = [String]()
        var wordToAdd: String = ""

        for index in 0..<elements.count {
            wordToAdd.append(elements[index])
            let currentWordIsNumeric: Bool = VocalizeCurrency.isNumeric(elements[index])
            var nextWordIsNumeric: Bool = false
            if index < elements.count - 1 {
                nextWordIsNumeric = VocalizeCurrency.isNumeric(elements[index + 1])
            }
            if !currentWordIsNumeric || !nextWordIsNumeric {
                result.append(wordToAdd)
                wordToAdd = ""
            }
        }

        return result.joined(separator: " ")
    }
}
