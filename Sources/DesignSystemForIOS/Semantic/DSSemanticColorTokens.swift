public enum DSSemanticColorTokens {
    public static let bgPage = DSCoreColorTokens.neutral50
    public static let bgSurface = DSCoreColorTokens.neutral0
    public static let bgMuted = DSCoreColorTokens.neutral100

    public static let textPrimary = DSCoreColorTokens.neutral900
    public static let textSecondary = DSCoreColorTokens.neutral700
    public static let textInverse = DSCoreColorTokens.neutral0

    public static let strokeSoft = DSCoreColorTokens.neutral200
    public static let strokeStrong = DSCoreColorTokens.neutral700

    public static let accentPrimary = DSCoreColorTokens.brand500
    public static let accentSoft = DSCoreColorTokens.brand100

    public static let glassFill = DSColorToken(
        light: DSRGBA(1.00, 1.00, 1.00, 0.62),
        dark: DSRGBA(0.11, 0.12, 0.15, 0.52)
    )
    public static let glassStroke = DSColorToken(
        light: DSRGBA(1.00, 1.00, 1.00, 0.82),
        dark: DSRGBA(1.00, 1.00, 1.00, 0.24)
    )
    public static let glassShadow = DSColorToken(
        light: DSRGBA(0.00, 0.00, 0.00, 0.14),
        dark: DSRGBA(0.00, 0.00, 0.00, 0.24)
    )

    public static let stateInfo = DSCoreColorTokens.info500
    public static let stateSuccess = DSCoreColorTokens.success500
    public static let stateWarning = DSCoreColorTokens.warning500
    public static let stateDanger = DSCoreColorTokens.danger500
}
