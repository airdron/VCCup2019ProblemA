// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Something wrong
  internal static let alertErrorDefaultMessage = L10n.tr("Localizable", "alert_error_default_message")
  /// Error
  internal static let alertErrorTitle = L10n.tr("Localizable", "alert_error_title")
  /// Unsupported file format
  internal static let alertErrorUnsupportedFormatMessage = L10n.tr("Localizable", "alert_error_unsupported_format_message")
  /// OK
  internal static let alertOkButton = L10n.tr("Localizable", "alert_ok_button")
  /// Wait
  internal static let alertWaitingTitle = L10n.tr("Localizable", "alert_waiting_title")
  /// Cancel
  internal static let cancelActionText = L10n.tr("Localizable", "cancel_action_text")
  /// Delete document
  internal static let deleteActionText = L10n.tr("Localizable", "delete_action_text")
  /// today
  internal static let documentsDateToday = L10n.tr("Localizable", "documents_date_today")
  /// yesterday
  internal static let documentsDateYesterday = L10n.tr("Localizable", "documents_date_yesterday")
  /// Documents
  internal static let documentsTitle = L10n.tr("Localizable", "documents_title")
  /// Login
  internal static let loginButton = L10n.tr("Localizable", "login_button")
  /// Rename
  internal static let renameActionText = L10n.tr("Localizable", "rename_action_text")
  /// %@ to
  internal static func renamingAlertMessage(_ p1: String) -> String {
    return L10n.tr("Localizable", "renaming_alert_message", p1)
  }
  /// Renaming
  internal static let renamingAlertTitle = L10n.tr("Localizable", "renaming_alert_title")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
