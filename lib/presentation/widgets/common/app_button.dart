import 'package:flutter/material.dart';
import '../../../core/constants/constants.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  text,
  glow,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _height,
      child: _buildButton(isDisabled),
    );
  }

  double get _height {
    switch (size) {
      case AppButtonSize.small:
        return 44;
      case AppButtonSize.medium:
        return 52;
      case AppButtonSize.large:
        return 56;
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.buttonSmall;
      case AppButtonSize.medium:
        return AppTypography.buttonMedium;
      case AppButtonSize.large:
        return AppTypography.buttonLarge;
    }
  }

  Widget _buildButton(bool isDisabled) {
    switch (variant) {
      case AppButtonVariant.primary:
        return _PrimaryButton(
          label: label,
          onPressed: onPressed,
          isDisabled: isDisabled,
          isLoading: isLoading,
          textStyle: _textStyle,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
        );
      case AppButtonVariant.glow:
        return _GlowButton(
          label: label,
          onPressed: onPressed,
          isDisabled: isDisabled,
          isLoading: isLoading,
          textStyle: _textStyle,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
        );
      case AppButtonVariant.secondary:
        return _SecondaryButton(
          label: label,
          onPressed: onPressed,
          isDisabled: isDisabled,
          isLoading: isLoading,
          textStyle: _textStyle,
        );
      case AppButtonVariant.outline:
        return _OutlineButton(
          label: label,
          onPressed: onPressed,
          isDisabled: isDisabled,
          isLoading: isLoading,
          textStyle: _textStyle,
        );
      case AppButtonVariant.text:
        return _TextButton(
          label: label,
          onPressed: onPressed,
          isDisabled: isDisabled,
          isLoading: isLoading,
          textStyle: _textStyle,
        );
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final bool isLoading;
  final TextStyle textStyle;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    required this.isDisabled,
    required this.isLoading,
    required this.textStyle,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDisabled ? AppColors.gray400 : AppColors.gray900,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(AppColors.white),
                  ),
                )
              : _ButtonContent(
                  label: label,
                  textStyle: textStyle.copyWith(color: AppColors.white),
                  leadingIcon: leadingIcon,
                  trailingIcon: trailingIcon,
                  iconColor: AppColors.white,
                ),
        ),
      ),
    );
  }
}

class _GlowButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final bool isLoading;
  final TextStyle textStyle;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  const _GlowButton({
    required this.label,
    required this.onPressed,
    required this.isDisabled,
    required this.isLoading,
    required this.textStyle,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDisabled ? null : AppColors.buttonGradient,
        color: isDisabled ? AppColors.gray400 : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        boxShadow: isDisabled ? null : AppShadows.button,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppColors.white),
                    ),
                  )
                : _ButtonContent(
                    label: label,
                    textStyle: textStyle.copyWith(color: AppColors.white),
                    leadingIcon: leadingIcon,
                    trailingIcon: trailingIcon,
                    iconColor: AppColors.white,
                  ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final bool isLoading;
  final TextStyle textStyle;

  const _SecondaryButton({
    required this.label,
    required this.onPressed,
    required this.isDisabled,
    required this.isLoading,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.gray600),
              ),
            )
          : Text(
              label,
              style: textStyle.copyWith(
                color: isDisabled ? AppColors.gray400 : AppColors.gray600,
              ),
            ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final bool isLoading;
  final TextStyle textStyle;

  const _OutlineButton({
    required this.label,
    required this.onPressed,
    required this.isDisabled,
    required this.isLoading,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isDisabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isDisabled ? AppColors.gray200 : AppColors.gray200,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.gray900),
              ),
            )
          : Text(
              label,
              style: textStyle.copyWith(
                color: isDisabled ? AppColors.gray400 : AppColors.gray900,
              ),
            ),
    );
  }
}

class _TextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final bool isLoading;
  final TextStyle textStyle;

  const _TextButton({
    required this.label,
    required this.onPressed,
    required this.isDisabled,
    required this.isLoading,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.pinkDark),
              ),
            )
          : Text(
              label,
              style: textStyle.copyWith(
                color: isDisabled ? AppColors.gray400 : AppColors.pinkDark,
              ),
            ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final String label;
  final TextStyle textStyle;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Color iconColor;

  const _ButtonContent({
    required this.label,
    required this.textStyle,
    this.leadingIcon,
    this.trailingIcon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 20, color: iconColor),
          const SizedBox(width: 8),
        ],
        Text(label, style: textStyle),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, size: 20, color: iconColor),
        ],
      ],
    );
  }
}
