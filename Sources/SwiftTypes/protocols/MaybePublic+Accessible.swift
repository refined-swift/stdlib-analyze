import Swift

extension MaybePublic where Self: Accessible {
    public var isPublic: Bool {
        return accessLevel == "public"
    }
}
