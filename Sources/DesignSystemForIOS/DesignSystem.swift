import SwiftUI

public enum DesignSystem {
    public static let version = "0.1.0"

    public enum Foundation {
        public typealias Color = DSCoreColorTokens
        public typealias Spacing = DSSpacingTokens
        public typealias Dimension = DSDimensionTokens
        public typealias Radius = DSRadiusTokens
        public typealias Stroke = DSStrokeTokens
        public typealias Typography = DSTypographyTokens
        public typealias Shadow = DSShadowTokens
        public typealias Motion = DSMotionTokens
        public typealias ThemeMode = DSThemeMode
        public typealias VisualStyle = DSVisualStyle
        public typealias VisualPolicy = DSVisualStylePolicy
        public typealias AccessibilitySnapshot = DSAccessibilitySnapshot
        public typealias SurfaceCapabilitySnapshot = DSStyleCapabilitySnapshot
        public typealias VisualStyleResolutionContext = DSVisualStyleResolutionContext
        public typealias VisualStyleResolver = DSVisualStyleResolver
        public typealias AccessibilityPolicy = DSAccessibilityPolicy
        public typealias DynamicTypePolicy = DSDynamicTypePolicy
    }

    public enum Semantic {
        public typealias Color = DSSemanticColorTokens
        public typealias Spacing = DSSemanticSpacingTokens
    }

    public enum Primitive {
        public typealias Surface = DSSurface
        public typealias Container = DSContainer
        public typealias State = DSStateView
    }

    public enum Component {
        public typealias Button = DSButton
        public typealias Tag = DSTag
        public typealias FormTextField = DSFormTextField
        public typealias ListRow = DSListRow
        public typealias TopBar = DSTopBar
        public typealias SheetScaffold = DSSheetScaffold
        public typealias ToastBanner = DSToastBanner
        public typealias InlineLoadingView = DSInlineLoadingView
    }
}
