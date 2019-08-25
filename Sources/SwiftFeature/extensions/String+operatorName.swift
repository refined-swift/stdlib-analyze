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
        case "==": return "Equal" // Equal to
        case "!=": return "Distinct" // Not equal to (Inequality)
        case "<": return "Less" // Less than
        case ">": return "Greater" // Greater than
        case "<=": return "Less equal" // Less than or equal to
        case ">=": return "Greater equal" // Greater than or equal to
        case ",": return "Comma"
        case "?": return "Conditional ternary"
        case "&": return "Bitwise AND"
        case "|": return "Bitwise OR" // Bitwise inclusive OR
        case "^": return "Bitwise XOR" // Bitwise exclusive OR
        case "~": return "Unary complement"
        case "<<": return "Left shift" // Shift bits left
        case ">>": return "Right shift" // Shift bits right
        case "||": return "OR" // Logical OR
        case "&&": return "AND" // Logical AND
        case "!": return "NOT" // Logical NOT
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
        case ".>=": return "Pointwise greater equal"
        case ".>": return "Pointwise greater"
        case ".<": return "Pointwise less"
        case ".<=": return "Pointwise less equal"
        case ".!=": return "Pointwise distinct"
        case ".==": return "Pointwise equal"
        case ".!": return "Pointwise NOT"
        case ".|": return "Pointwise bitwise OR"
        case ".^": return "Pointwise bitwise XOR"
        case ".&": return "Pointwise bitwise AND"
        case "&<<": return "Overflow left shift"
        case "&>>": return "Overflow right shift"
        default: return nil
        }
    }
}
