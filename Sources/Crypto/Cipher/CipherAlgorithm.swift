import CNIOOpenSSL

/// Specifies a cipher algorithm (e.g., AES128-ECB) to be used with a `Cipher`.
///
/// Common cipher algorithms are provided as static properties on this class.
///
/// There are also static methods for creating `CipherAlgorithm` such as `CipherAlgorithm.named(_:)`
public final class CipherAlgorithm {
    // MARK: Static

    /// Looks up a cipher function algorithm by name (e.g., "aes-128-cbc").
    /// Uses OpenSSL's `EVP_get_cipherbyname` function.
    ///
    ///     let algorithm = try CipherAlgorithm.named("aes-128-cbc")
    ///
    /// - parameters:
    ///     - name: Cipher function name
    /// - returns: Found `CipherAlgorithm`
    /// - throws: `CryptoError` if no cipher for that name is found.
    public static func named(_ name: String) throws -> CipherAlgorithm {
        guard let cipher = EVP_get_cipherbyname(name) else {
            throw CryptoError.openssl(identifier: "EVP_get_cipherbyname", reason: "No cipher named \(name) was found.")
        }
        return .init(c: cipher)
    }

    /// AES-128 ECB cipher.
    public static let aes128ecb: CipherAlgorithm = .init(c: EVP_aes_128_ecb())

    /// AES-256 ECB cipher.
    public static let aes256ecb: CipherAlgorithm = .init(c: EVP_aes_256_ecb())

    /// AES-128 CBC cipher.
    public static let aes128cbc: CipherAlgorithm = .init(c: EVP_aes_128_cbc())

    /// AES-256 CBC cipher.
    public static let aes256cbc: CipherAlgorithm = .init(c: EVP_aes_256_cbc())

    /// AES-128 CFB cipher.
    public static let aes128cfb: CipherAlgorithm = .init(c: EVP_aes_128_cfb128())

    /// AES-256 CFB cipher.
    public static let aes256cfb: CipherAlgorithm = .init(c: EVP_aes_256_cfb128())

    /// OpenSSL `EVP_CIPHER` context.
    public let c: UnsafePointer<EVP_CIPHER>

    /// Internal init accepting a `EVP_CIPHER`.
    public init(c: UnsafePointer<EVP_CIPHER>) {
        self.c = c
    }

    // MARK: Instance

    /// Returns the OpenSSL NID type for this algorithm.
    public var type: Int32 {
        return EVP_CIPHER_type(c)
    }

    /// This cipher's required key length.
    public var keySize: Int32 {
        return EVP_CIPHER_key_length(c)
    }

    /// This cipher's required initialization vector length.
    public var ivSize: Int32 {
        return EVP_CIPHER_iv_length(c)
    }

    /// This cipher's block size, used internally to allocate "out" buffers.
    public var blockSize: Int32 {
        return EVP_CIPHER_block_size(c)
    }
}
