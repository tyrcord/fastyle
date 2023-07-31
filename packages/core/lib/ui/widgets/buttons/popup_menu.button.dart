// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastPopupMenuButton<T> extends StatefulWidget {
  /// Called when the button is pressed to create the items to show in the menu.
  final PopupMenuItemBuilder<T> itemBuilder;

  /// The value of the menu item, if any, that should be highlighted when
  /// the menu opens.
  final T? initialValue;

  /// Called when the popup menu is shown.
  final VoidCallback? onOpened;

  /// Called when the user selects a value from the popup menu created by this
  /// button.
  ///
  /// If the popup menu is dismissed without selecting a value, [onCanceled] is
  /// called instead.
  final PopupMenuItemSelected<T>? onSelected;

  /// Called when the user dismisses the popup menu without selecting an item.
  ///
  /// If the user selects a value, [onSelected] is called instead.
  final PopupMenuCanceled? onCanceled;

  /// Text that describes the action that will occur when the button is pressed.
  ///
  /// This text is displayed when the user long-presses on the button and is
  /// used for accessibility.
  final String? tooltip;

  /// The z-coordinate at which to place the menu when open. This controls the
  /// size of the shadow below the menu.
  ///
  /// Defaults to 8, the appropriate elevation for popup menus.
  final double? elevation;

  /// The color used to paint the shadow below the menu.
  ///
  /// If null then the ambient [PopupMenuThemeData.shadowColor] is used.
  /// If that is null too, then the overall theme's [ThemeData.shadowColor]
  /// (default black) is used.
  final Color? shadowColor;

  /// Matches IconButton's 8 dps padding by default. In some cases, notably
  /// where this button appears as the trailing element of a list item,
  /// it's useful to be able to set the padding to zero.
  final EdgeInsetsGeometry padding;

  /// If provided, [child] is the widget used for this button
  /// and the button will utilize an [InkWell] for taps.
  final Widget? child;

  /// If provided, the [icon] is used for this button
  /// and the button will behave like an [IconButton].
  final Widget icon;

  /// The offset is applied relative to the initial position
  /// set by the [position].
  ///
  /// When not set, the offset defaults to [Offset.zero].
  final Offset offset;

  /// Whether this popup menu button is interactive.
  ///
  /// Must be non-null, defaults to `true`
  ///
  /// If `true` the button will respond to presses by displaying the menu.
  ///
  /// If `false`, the button is styled with the disabled color from the
  /// current [Theme] and will not respond to presses or show the popup
  /// menu and [onSelected], [onCanceled] and [itemBuilder] will not be called.
  ///
  /// This can be useful in situations where the app needs to show the button,
  /// but doesn't currently have anything to show in the menu.
  final bool enabled;

  /// If provided, the shape used for the menu.
  ///
  /// If this property is null, then [PopupMenuThemeData.shape] is used.
  /// If [PopupMenuThemeData.shape] is also null, then the default shape for
  /// [MaterialType.card] is used. This default shape is a rectangle with
  /// rounded edges of BorderRadius.circular(2.0).
  final ShapeBorder? shape;

  /// If provided, the background color used for the menu.
  ///
  /// If this property is null, then [PopupMenuThemeData.color] is used.
  /// If [PopupMenuThemeData.color] is also null, then
  /// Theme.of(context).cardColor is used.
  final Color? color;

  /// If provided, the size of the [Icon].
  ///
  /// If this property is null, then [IconThemeData.size] is used.
  /// If [IconThemeData.size] is also null, then
  /// default size is 24.0 pixels.
  final double iconSize;

  /// Optional size constraints for the menu.
  ///
  /// When unspecified, defaults to:
  /// ```dart
  /// const BoxConstraints(
  ///   minWidth: 2.0 * 56.0,
  ///   maxWidth: 5.0 * 56.0,
  /// )
  /// ```
  ///
  /// The default constraints ensure that the menu width matches maximum width
  /// recommended by the Material Design guidelines.
  /// Specifying this parameter enables creation of menu wider than
  /// the default maximum width.
  final BoxConstraints? constraints;

  /// Whether the popup menu is positioned over or under the popup menu button.
  ///
  /// [offset] is used to change the position of the popup menu relative to the
  /// position set by this parameter.
  ///
  /// If this property is `null`, then [PopupMenuThemeData.position] is used. If
  /// [PopupMenuThemeData.position] is also `null`, then the position defaults
  /// to [PopupMenuPosition.over] which makes the popup menu appear directly
  /// over the button that was used to create it.
  final PopupMenuPosition? position;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// The [clipBehavior] argument is used the clip shape of the menu.
  ///
  /// Defaults to [Clip.none], and must not be null.
  final Clip clipBehavior;

  final Alignment iconAlignment;

  const FastPopupMenuButton({
    super.key,
    required this.itemBuilder,
    required this.icon,
    this.initialValue,
    this.onOpened,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.shadowColor,
    this.offset = Offset.zero,
    this.enabled = true,
    this.shape,
    this.color,
    this.constraints,
    this.position,
    this.child,
    this.clipBehavior = Clip.none,
    EdgeInsetsGeometry? padding,
    double? iconSize,
    Alignment? iconAlignment,
  })  : iconAlignment = iconAlignment ?? Alignment.center,
        iconSize = iconSize ?? kFastIconSizeSmall,
        padding = padding ?? kFastEdgeInsets8;

  @override
  State<FastPopupMenuButton<T>> createState() => _FastPopupMenuButtonState<T>();
}

class _FastPopupMenuButtonState<T> extends State<FastPopupMenuButton<T>> {
  @override
  Widget build(BuildContext context) {
    return FastIconButton(
      onTap: () => showButtonMenu(context),
      iconAlignment: widget.iconAlignment,
      iconSize: widget.iconSize,
      isEnabled: widget.enabled,
      padding: widget.padding,
      tooltip: widget.tooltip,
      icon: widget.icon,
    );
  }

  void showButtonMenu(BuildContext context) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final PopupMenuPosition popupMenuPosition =
        widget.position ?? popupMenuTheme.position ?? PopupMenuPosition.over;
    final Offset offset;

    switch (popupMenuPosition) {
      case PopupMenuPosition.over:
        offset = widget.offset;
      case PopupMenuPosition.under:
        offset =
            Offset(0.0, button.size.height - (widget.padding.vertical / 2)) +
                widget.offset;
    }

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset,
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final List<PopupMenuEntry<T>> items = widget.itemBuilder(context);
    // Only show the menu if there is something to show

    final defaultColor =
        ThemeHelper.colors.getSecondaryBackgroundColor(context);

    if (items.isNotEmpty) {
      widget.onOpened?.call();

      showMenu<T?>(
        shadowColor: widget.shadowColor ?? popupMenuTheme.shadowColor,
        elevation: widget.elevation ?? popupMenuTheme.elevation,
        surfaceTintColor: widget.color ?? defaultColor,
        shape: widget.shape ?? popupMenuTheme.shape,
        clipBehavior: widget.clipBehavior,
        initialValue: widget.initialValue,
        constraints: widget.constraints,
        context: context,
        position: position,
        items: items,
      ).then<void>((T? newValue) {
        if (!mounted) {
          return null;
        }

        if (newValue == null) {
          widget.onCanceled?.call();

          return null;
        }

        widget.onSelected?.call(newValue);
      });
    }
  }
}
