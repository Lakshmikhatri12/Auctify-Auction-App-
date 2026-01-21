import 'package:auctify/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
    this.bottom,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: showBack && Navigator.canPop(context),
      leading: showBack && Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),

      actions: actions,
      bottom: bottom,
    );
  }
}
