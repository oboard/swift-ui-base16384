import Foundation

func align<T: UnsignedInteger, U: UnsignedInteger>(input: [T], output: inout [U], sWidth: Int, tWidth: Int, sOffset: Int, tOffset: Int) {
    var offset = 0
    var rest = 0
    var i = 0, j = 0
    let mask = (1 << tWidth) - 1
    
    while i < input.count {
        let char = Int(input[i]) - sOffset
        offset += sWidth
        
        while offset >= tWidth {
            offset -= tWidth
            var out = rest + (char >> offset) + tOffset;
            if (out < 0) {
                out = 0
            }
            output[j] = U(out)
            j += 1
            
            if j == output.count {
                return
            }
            rest = 0
        }
        
        rest += (char << (tWidth - offset)) & mask
        i += 1
    }
    
    if offset != 0 {
        output[j] = U(rest + tOffset)
        j += 1;
    }
}

func toUint8Array(source: String) -> [UInt8] {
    return Array(source.utf8)
}

func encode(input: [UInt8]) -> [UInt16] {
    let count = Int(ceil(Double(input.count)*4/7)) + 1
    var output = [UInt16](repeating: 0, count: count)
    align(input: input, output: &output, sWidth: 8, tWidth: 14, sOffset: 0, tOffset: 0x4e00)
    output[output.count - 1] = UInt16(input.count % 7 + 0x3d00)
    return output
}

func toUint16Array(source: String) -> [UInt16] {
    return source.utf16.map { UInt16($0) }
}

func performSafeSubtraction(_ a: Int, _ b: Int) -> Int? {
    do {
        let result = try a.subtractingReportingOverflow(b)
        if result.overflow {
            return nil
        }
        return result.partialValue
    } catch {
        return nil
    }
}

func decode(input: [UInt16]) -> [UInt8]  {
    let length = input.count - 1
    if (length < 0) {
        return [UInt8]();
    }
    var residue = Int(performSafeSubtraction(Int(input[length]), 0x3d00) ?? 7)
    
    if (residue <= 0) {
        residue = 7
    }
    var output = [UInt16](repeating: 0, count: Int(floor((length - 1) / 4)) * 7 + residue)
    align(input: input, output: &output, sWidth: 14, tWidth: 8, sOffset: 0x4e00, tOffset: 0)
    return output.map { UInt8($0 % 256) }
}

func toSource8(input: [UInt8]) -> String {
    return String(data: Data(input), encoding: .utf8) ?? ""
}

func toSource(input: [UInt16]) -> String {
    let characters = input.map { Character(UnicodeScalar($0)!) }
    return String(characters)
}


// Test
//let sourceString = "早上好"
//let encodedArray = encode(input: toUint8Array(source: sourceString))
let encodedStr = "螥袞惢壥睯帀㴂"
let decodedArray = decode(input: toUint16Array(source: encodedStr))

print("Decoded Array: \(decodedArray)")
