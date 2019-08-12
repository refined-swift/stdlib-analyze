import Swift

extension String {
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    static func operatorName(_ operator: String) -> String? {
        switch `operator` {
        case "+": return "Addition"
        case "-": return "Subtraction"
        case "*": return "Multiplication"
        case "/": return "Division"
        case "%": return "Modulo"
        case "++": return "Increment"
        case "--": return "Decrement"
        case "==": return "Equal to"
        case "!=": return "Not equal to"
        case "<": return "Less than"
        case ">": return "Greater than"
        case "<=": return "Less than or equal to"
        case ">=": return "Greater than or equal to"
        case ",": return "Comma"
        case "?": return "Conditional ternary"
        case "&": return "Bitwise AND"
        case "|": return "Bitwise inclusive OR"
        case "^": return "Bitwise exclusive OR"
        case "~": return "Unary complement"
        case "<<": return "Shift bits left"
        case ">>": return "Shift bits right"
        case "||": return "Logical OR"
        case "&&": return "Logical AND"
        case "!": return "Logical NOT"
        case "::": return "Scope qualifier"
        case "+=": return "Compound addition assignment"
        case "-=": return "Compound subtraction assignment"
        case "*=": return "Compound multiplication assignment"
        case "/=": return "Compound division assignment"
        case "%=": return "Compound modulo assignment"
        case ">>=": return "Compound shift bits right assignment"
        case "<<=": return "Compound shift bits left assignment"
        case "&=": return "Compound bitwise AND assignment"
        case "^=": return "Compound bitwise exclusive OR assignment"
        case "|=": return "Compound bitwise inclusive OR assignment"
        case "&+": return "Overflow addition"
        case "&-": return "Overflow subtraction"
        case "&*": return "Overflow multiplication"
        case "??": return "Nil-Coalescing"
        case "...": return "Closed Range"
        case "..<": return "Half-Open Range"
        default: return nil
        }
    }
}
