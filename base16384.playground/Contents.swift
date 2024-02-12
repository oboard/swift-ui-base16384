import Foundation



enum TypedArray {
    typealias Uint8Array = [UInt8]
    typealias Uint16Array = [UInt16]
}

func align(input: TypedArray.Uint8Array, output: inout TypedArray.Uint16Array, sWidth: Int, tWidth: Int, sOffset: Int, tOffset: Int) {
    var offset = 0
    var rest = 0
    var i = 0, j = 0
    let mask = (1 << tWidth) - 1
    
    while i < input.count {
        let char = Int(input[i]) - sOffset
        offset += sWidth
        
        while offset >= tWidth {
            offset -= tWidth
            output[j] = UInt16(rest + (char >> offset) + tOffset)
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
        output[j] = UInt16(rest + tOffset)
        j += 1;
    }
}

func toUint8Array(source: String) -> TypedArray.Uint8Array {
    return Array(source.utf8)
}

func encode(input: String) -> TypedArray.Uint16Array {
    let inputArray = toUint8Array(source: input)
    let count = Int(ceil(Double(input.count)*4/7))+1
    var output = TypedArray.Uint16Array(repeating: 0, count: count)
    align(input: inputArray, output: &output, sWidth: 8, tWidth: 14, sOffset: 0, tOffset: 0x4e00)
    output[output.count-1] = UInt16((inputArray.count) % 7 + 0x3d00)
    return output
}

func toUint16Array(source: String) -> TypedArray.Uint16Array {
    return source.utf16.map { UInt16($0) }
}
func convertUInt16ArrayToUInt8Array(_ input: [UInt16]) -> [UInt8] {
    var output = [UInt8]()
    
    input.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) in
        let uint8Ptr = ptr.bindMemory(to: UInt8.self)
        output.append(contentsOf: uint8Ptr)
    }
    
    return output
}

func decode(input: TypedArray.Uint16Array) -> TypedArray.Uint8Array {
    let length = input.count - 1
    let input8 = convertUInt16ArrayToUInt8Array(input)
    var residue = Int(input[length] - 0x3d00)
    if (residue == 0) {
        residue = 7
    }
    var output = TypedArray.Uint16Array(repeating: 0, count: (length - 1) / 4 * 7 + residue)
    align(input: input8, output: &output, sWidth: 14, tWidth: 8, sOffset: 0x4e00, tOffset: 0)
    
    return convertUInt16ArrayToUInt8Array(output)
}


func toSource(input: TypedArray.Uint16Array) -> String {
    let characters = input.map { Character(UnicodeScalar($0)!) }
    return String(characters)
}
//
// Test
let sourceString = "你"
let encodedArray = encode(input: sourceString)
//let decodedArray = decode(input: encodedArray)

print("Source String: \(sourceString)")
print("Encoded Array: \(encodedArray)")
//print("Decoded Array: \(decodedArray)")
